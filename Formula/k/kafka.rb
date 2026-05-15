class Kafka < Formula
  desc "Open-source distributed event streaming platform"
  homepage "https://kafka.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=kafka/4.2.0/kafka_2.13-4.2.0.tgz"
  mirror "https://archive.apache.org/dist/kafka/4.2.0/kafka_2.13-4.2.0.tgz"
  sha256 "6649427c2d062908a1fa0b941d8d2274f52536202faa1b13e3545b395a2285fb"
  license "Apache-2.0"

  livecheck do
    url "https://kafka.apache.org/community/downloads/"
    regex(/href=.*?kafka[._-]v?\d+(?:\.\d+)+-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ee46368fdc79460ab6daf0fddd2c77fb0cacaeb443c15709df4b3e04ecb655e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ee46368fdc79460ab6daf0fddd2c77fb0cacaeb443c15709df4b3e04ecb655e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ee46368fdc79460ab6daf0fddd2c77fb0cacaeb443c15709df4b3e04ecb655e"
    sha256 cellar: :any_skip_relocation, sonoma:        "7465df0f80bf5e807516380472d47e9c3c272ad1ec6d2f32f9ed25998076299b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ee46368fdc79460ab6daf0fddd2c77fb0cacaeb443c15709df4b3e04ecb655e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ee46368fdc79460ab6daf0fddd2c77fb0cacaeb443c15709df4b3e04ecb655e"
  end

  depends_on "openjdk"

  def install
    data = var/"lib"

    inreplace "config/server.properties",
      "log.dirs=/tmp/kraft-combined-logs", "log.dirs=#{data}/kraft-combined-logs"
    inreplace "config/controller.properties",
      "log.dirs=/tmp/kraft-controller-logs", "log.dirs=#{data}/kraft-controller-logs"
    inreplace "config/connect-standalone.properties",
      "filename=/tmp/connect.offsets", "filename=#{data}/connect.offsets"
    inreplace "config/broker.properties",
      "log.dirs=/tmp/kraft-broker-logs", "log.dirs=#{data}/kraft-broker-logs"

    # remove Windows scripts
    rm_r("bin/windows")

    libexec.install "libs"

    prefix.install "bin"
    bin.env_script_all_files(libexec/"bin", Language::Java.overridable_java_home_env)
    Dir["#{bin}/*.sh"].each { |f| mv f, f.to_s.gsub(/.sh$/, "") }

    mv "config", "kafka"
    etc.install "kafka"
    libexec.install_symlink etc/"kafka" => "config"
  end

  def post_install
    # create directory for kafka stdout+stderr output logs when run by launchd
    (var/"log/kafka").mkpath

    generate_log_dir(etc/"kafka/server.properties") unless (var/"lib/kraft-combined-logs/meta.properties").exist?
  end

  def generate_log_dir(path)
    uuid = Utils.safe_popen_read(bin/"kafka-storage", "random-uuid").strip
    system bin/"kafka-storage", "format", "--standalone",
           "-t", uuid, "-c", path
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

    # Workaround for https://issues.apache.org/jira/browse/KAFKA-15413
    # See https://github.com/Homebrew/homebrew-core/pull/133887#issuecomment-1679907729
    ENV.delete "COLUMNS"

    (testpath/"kafka").mkpath
    cp "#{etc}/kafka/server.properties", testpath/"kafka"

    kafka_port = free_port
    controller_port = free_port
    inreplace "#{testpath}/kafka/server.properties" do |s|
      s.gsub! "#{var}/lib", testpath
      s.gsub! "controller.quorum.bootstrap.servers=localhost:9093",
              "controller.quorum.bootstrap.servers=localhost:#{controller_port}"
      s.gsub! "listeners=PLAINTEXT://:9092,CONTROLLER://:9093",
              "listeners=PLAINTEXT://:#{kafka_port},CONTROLLER://:#{controller_port}"
      s.gsub! "advertised.listeners=PLAINTEXT://localhost:9092,CONTROLLER://localhost:9093",
              "advertised.listeners=PLAINTEXT://localhost:#{kafka_port},CONTROLLER://localhost:#{controller_port}"
    end

    generate_log_dir(testpath/"kafka/server.properties")

    begin
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
      system bin/"kafka-server-stop"
      sleep 10
    end

    assert_match(/test message/, File.read("#{testpath}/kafka/demo.out"))
  end
end
