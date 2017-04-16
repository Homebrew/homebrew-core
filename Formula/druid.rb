class Druid < Formula
  desc "High-performance, column-oriented, distributed data store"
  homepage "http://druid.io"
  url "http://static.druid.io/artifacts/releases/druid-0.9.2-bin.tar.gz"
  sha256 "10cb45d36c72ba4e4b7029c35bdfae0974b7950241ab06acaa8f8e284d1a989f"

  bottle :unneeded

  depends_on "zookeeper"
  depends_on :java => "1.8+"

  def install
    libexec.install Dir["*"]
    cd libexec do
      system "bin/init"
    end
  end

  test do
    ENV["DRUID_CONF_DIR"] = "conf-quickstart/druid"
    ENV["DRUID_LOG_DIR"] = testpath
    ENV["DRUID_PID_DIR"] = testpath

    cd libexec do
      begin
        fork { exec "bin/broker.sh start" }
        sleep 30
        output = shell_output("curl -s http://localhost:8082/status")
        assert_match /version/m, output
      ensure
        system "bin/broker.sh", "stop"
      end
    end
  end
end
