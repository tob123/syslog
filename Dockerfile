FROM ubuntu:focal
COPY files /
#environment variables to set befor rsyslog config validation is executed
ENV ENABLE_TOKAFKA="on" ENABLE_STATISTICS="on" ENABLE_LOGLOCAL="off" ENABLE_LOGFILES="on" SYSLOG_PORT="5140" ENABLE_REMOTE_SYSLOG="off"
    
RUN set -e ; \
    set -x ; \
    apt-get update && apt-get install --no-install-recommends --yes \
#    get packages to allow syslog to receive logs from kafka or to push logs to kafka
    rsyslog \
    rsyslog-kafka \
    rsyslog-relp; \
    mkdir /var/log2 ;\
    rm -rf /var/lib/apt/lists/* ; \
    rm -rf /root/.cache/pip ; \
    rm -rf /var/cache/apt; \
    adduser --system --no-create-home --group syslog \
#optionally give the system user a shell
#    --shell /bin/bash \
    ; \
    chown syslog:syslog /var/log2; \
    rsyslogd -N 1 -f /etc/rsyslog_cont.conf
USER syslog
CMD ["/usr/sbin/rsyslogd", "-n", "-f", "/etc/rsyslog_cont.conf"]
