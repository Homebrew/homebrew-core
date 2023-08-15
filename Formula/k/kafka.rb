class Kafka < Formula
  desc "Open-source distributed event streaming platform"
  homepage "https://kafka.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=kafka/3.5.1/kafka_2.13-3.5.1.tgz"
  mirror "https://archive.apache.org/dist/kafka/3.5.1/kafka_2.13-3.5.1.tgz"
  sha256 "f7b74d544023f2c0ec52a179de59975cb64e34ea03650d829328b407b560e4da"
  license "Apache-2.0"

  livecheck do
    url "https://kafka.apache.org/downloads"
    regex(/href=.*?kafka[._-]v?\d+(?:\.\d+)+-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "563718c3e8b37ed6e6fb7c70b7f03cf77f79439be7f07e48b2e6b596189387ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81209b8ead942df98c4972e05fb8499d0ae987681adcd9ec9e5d714ee702c44c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "819102974d57365dab3a009bf793e43935e9ee0d1e70c3202c1fa9c45fa3aaeb"
    sha256 cellar: :any_skip_relocation, ventura:        "aa2865ded7a9001ed89cfa90c3758d25e3716096dfd91f11909dacc5ff0d0faa"
    sha256 cellar: :any_skip_relocation, monterey:       "e51aed7bfeb7e4a8928a14cacb25802ce778e28ad61db16faf8ce855706bdbf7"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f2a380a432eaed351ef6bcd539bbe4dc71b4d526858192867b96b85b80c6729"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "890e6a2a5fa039cbb46dbe3e31573516ac294824a9f2b3f7dfda559f753e0590"
  end

  depends_on "openjdk"
  depends_on "zookeeper"

  def install
    data = var/"lib"
    inreplace "config/server.properties",
      "log.dirs=/tmp/kafka-logs", "log.dirs=#{data}/kafka-logs"

    inreplace "config/kraft/server.properties",
      "log.dirs=/tmp/kraft-combined-logs", "log.dirs=#{data}/kraft-combined-logs"

    inreplace "config/kraft/controller.properties",
      "log.dirs=/tmp/kraft-controller-logs", "log.dirs=#{data}/kraft-controller-logs"

    inreplace "config/kraft/broker.properties",
      "log.dirs=/tmp/kraft-broker-logs", "log.dirs=#{data}/kraft-broker-logs"

    inreplace "config/zookeeper.properties",
      "dataDir=/tmp/zookeeper", "dataDir=#{data}/zookeeper"

    # remove Windows scripts
    rm_rf "bin/windows"

    libexec.install "libs"

    prefix.install "bin"
    bin.env_script_all_files(libexec/"bin", Language::Java.overridable_java_home_env)
    Dir["#{bin}/*.sh"].each { |f| mv f, f.to_s.gsub(/.sh$/, "") }

    mv "config", "kafka"
    etc.install "kafka"
    libexec.install_symlink etc/"kafka" => "config"

    # create directory for kafka stdout+stderr output logs when run by launchd
    (var+"log/kafka").mkpath
  end

  service do
    run [opt_bin/"kafka-server-start", etc/"kafka/server.properties"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/kafka/kafka_output.log"
    error_log_path var/"log/kafka/kafka_output.log"
  end

  test do
    ENV["LOG_DIR"] = "#{testpath}/kafkalog"

    (testpath/"kafka").mkpath
    cp "#{etc}/kafka/zookeeper.properties", testpath/"kafka"
    cp "#{etc}/kafka/server.properties", testpath/"kafka"
    inreplace "#{testpath}/kafka/zookeeper.properties", "#{var}/lib", testpath
    inreplace "#{testpath}/kafka/server.properties", "#{var}/lib", testpath

    zk_port = free_port
    kafka_port = free_port
    inreplace "#{testpath}/kafka/zookeeper.properties", "clientPort=2181", "clientPort=#{zk_port}"
    inreplace "#{testpath}/kafka/server.properties" do |s|
      s.gsub! "zookeeper.connect=localhost:2181", "zookeeper.connect=localhost:#{zk_port}"
      s.gsub! "#listeners=PLAINTEXT://:9092", "listeners=PLAINTEXT://:#{kafka_port}"
    end

    begin
      fork do
        exec "#{bin}/zookeeper-server-start #{testpath}/kafka/zookeeper.properties " \
             "> #{testpath}/test.zookeeper-server-start.log 2>&1"
      end

      sleep 15

      fork do
        exec "#{bin}/kafka-server-start #{testpath}/kafka/server.properties " \
             "> #{testpath}/test.kafka-server-start.log 2>&1"
      end

      sleep 30

      system "#{bin}/kafka-topics --bootstrap-server localhost:#{kafka_port} --create --if-not-exists " \
             "--replication-factor 1 --partitions 1 --topic test > #{testpath}/kafka/demo.out " \
             "2>/dev/null"
      pipe_output "#{bin}/kafka-console-producer --bootstrap-server localhost:#{kafka_port} --topic test 2>/dev/null",
                  "test message"
      system "#{bin}/kafka-console-consumer --bootstrap-server localhost:#{kafka_port} --topic test " \
             "--from-beginning --max-messages 1 >> #{testpath}/kafka/demo.out 2>/dev/null"
      system "#{bin}/kafka-topics --bootstrap-server localhost:#{kafka_port} --delete --topic test " \
             ">> #{testpath}/kafka/demo.out 2>/dev/null"
    ensure
      system "#{bin}/kafka-server-stop"
      system "#{bin}/zookeeper-server-stop"
      sleep 10
    end

    assert_match(/test message/, File.read("#{testpath}/kafka/demo.out"))
  end
end
