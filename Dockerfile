FROM centos:7

MAINTAINER Clement Laforet <sheepkiller@cultdeadsheep.org>

RUN yum update -y && \
    yum install -y java-1.8.0-openjdk-headless && \
    yum clean all

ENV JAVA_HOME=/usr/java/default/ \
    ZK_HOSTS=localhost:2181 \
    KM_VERSION=2.0.0.2 \
    KM_REVISION=9f82c0fe5a9c74278bd4fce7feecfca538002028 \
    KM_CONFIGFILE="conf/application.conf"

ADD start-kafka-manager.sh /kafka-manager-${KM_VERSION}/start-kafka-manager.sh

RUN yum install -y java-1.8.0-openjdk-devel git wget unzip which && \
    mkdir -p /tmp && \
    cd /tmp && \
    git clone https://github.com/InspurKelly/kafka-manager.git && \
    cd /tmp/kafka-manager && \
    echo 'scalacOptions ++= Seq("-Xmax-classfile-name", "200")' >> build.sbt && \
    ./sbt clean dist && \
    unzip  -d / ./target/universal/kafka-manager-${KM_VERSION}.zip && \
    rm -fr /tmp/* /root/.sbt /root/.ivy2 && \
    chmod +x /kafka-manager-${KM_VERSION}/start-kafka-manager.sh && \
    yum autoremove -y java-1.8.0-openjdk-devel git wget unzip which && \
    yum clean all

WORKDIR /kafka-manager-${KM_VERSION}

EXPOSE 9000
ENTRYPOINT ["./start-kafka-manager.sh"]
