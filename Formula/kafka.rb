class Kafka < Formula
  desc "Publish-subscribe messaging rethought as a distributed commit log"
  homepage "https://kafka.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=kafka/2.7.0/kafka_2.13-2.7.0.tgz"
  mirror "https://archive.apache.org/dist/kafka/2.7.0/kafka_2.13-2.7.0.tgz"
  sha256 "1dd84b763676a02fecb48fa5d7e7e94a2bf2be9ff87bce14cf14109ce1cb7f90"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "ca872162f6fd02dc02a554a2c84f3b92cb5b2648f92dd8e0daf16eae6fd02ed3" => :big_sur
    sha256 "ab63bbcd513acd2c9d39fda4f1888e5a8d96d3df819fb05b1c50e75fc3d2230f" => :catalina
    sha256 "c7ef596aafc4e23c1144348e4e258e892135db6d9cebbd4d1a2a3d0da009ec79" => :mojave
  end

  depends_on "openjdk"
  depends_on "zookeeper"

  def install
    data = var/"lib"
    inreplace "config/server.properties",
      "log.dirs=/tmp/kafka-logs", "log.dirs=#{data}/kafka-logs"

    inreplace "config/zookeeper.properties",
      "dataDir=/tmp/zookeeper", "dataDir=#{data}/zookeeper"

    # remove Windows scripts
    rm_rf "bin/windows"

    libexec.install "libs"

    prefix.install "bin"
    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env)
    Dir["#{bin}/*.sh"].each { |f| mv f, f.to_s.gsub(/.sh$/, "") }

    mv "config", "kafka"
    etc.install "kafka"
    libexec.install_symlink etc/"kafka" => "config"

    # create directory for kafka stdout+stderr output logs when run by launchd
    (var+"log/kafka").mkpath
  end

  plist_options manual: "zookeeper-server-start #{HOMEBREW_PREFIX}/etc/kafka/zookeeper.properties & kafka-server-start #{HOMEBREW_PREFIX}/etc/kafka/server.properties"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>WorkingDirectory</key>
          <string>#{HOMEBREW_PREFIX}</string>
          <key>ProgramArguments</key>
          <array>
              <string>#{opt_bin}/kafka-server-start</string>
              <string>#{etc}/kafka/server.properties</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>KeepAlive</key>
          <true/>
          <key>StandardErrorPath</key>
          <string>#{var}/log/kafka/kafka_output.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/kafka/kafka_output.log</string>
      </dict>
      </plist>
    EOS
  end

  test do
    ENV["LOG_DIR"] = "#{testpath}/kafkalog"

    (testpath/"kafka").mkpath
    cp "#{etc}/kafka/zookeeper.properties", testpath/"kafka"
    cp "#{etc}/kafka/server.properties", testpath/"kafka"
    inreplace "#{testpath}/kafka/zookeeper.properties", "#{var}/lib", testpath
    inreplace "#{testpath}/kafka/server.properties", "#{var}/lib", testpath

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

      system "#{bin}/kafka-topics --zookeeper localhost:2181 --create --if-not-exists --replication-factor 1 " \
             "--partitions 1 --topic test > #{testpath}/kafka/demo.out 2>/dev/null"
      pipe_output "#{bin}/kafka-console-producer --broker-list localhost:9092 --topic test 2>/dev/null",
                  "test message"
      system "#{bin}/kafka-console-consumer --bootstrap-server localhost:9092 --topic test --from-beginning " \
             "--max-messages 1 >> #{testpath}/kafka/demo.out 2>/dev/null"
      system "#{bin}/kafka-topics --zookeeper localhost:2181 --delete --topic test >> #{testpath}/kafka/demo.out " \
             "2>/dev/null"
    ensure
      system "#{bin}/kafka-server-stop"
      system "#{bin}/zookeeper-server-stop"
      sleep 10
    end

    assert_match(/test message/, IO.read("#{testpath}/kafka/demo.out"))
  end
end
