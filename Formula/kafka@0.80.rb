class KafkaAT080 < Formula
  desc "Publish-subscribe messaging rethought as a distributed commit log"
  homepage "https://kafka.apache.org"
  url "https://archive.apache.org/dist/kafka/0.8.0/kafka-0.8.0-src.tgz"
  sha256 "f4b7229671aba98dba9a882244cb597aab8a9018631575d28e119725a01cfc9a"

  depends_on "zookeeper"
  depends_on :java => "1.7"

  def install
    ENV.java_cache

    system "./sbt", "update"
    system "./sbt", "package"
    system "./sbt", "assembly-package-dependency"

    # Use 1 partition by default so individual consumers receive all topic messages
    inreplace "config/server.properties", "num.partitions=2", "num.partitions=1"

    logs = var/"log/kafka"
    inreplace "config/log4j.properties", ".File=logs/", ".File=#{logs}/"
    inreplace "config/test-log4j.properties", ".File=logs/", ".File=#{logs}/"

    data = var/"lib"
    inreplace "config/server.properties",
              "log.dirs=/tmp/kafka-logs", "log.dirs=#{data}/kafka-logs"

    inreplace "config/zookeeper.properties",
              "dataDir=/tmp/zookeeper", "dataDir=#{data}/zookeeper"

    libexec.install %w[contrib core examples lib perf system_test]

    prefix.install "bin"
    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env("1.7"))

    (etc/"kafka").install Dir["config/*"]
  end

  def caveats; <<-EOS.undent
    To start Kafka, ensure that ZooKeeper is running and then execute:
      kafka-server-start.sh #{etc}/kafka/server.properties
    EOS
  end
end
