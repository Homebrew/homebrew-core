class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/v2.1.2.tar.gz"
  sha256 "2fdbda70191ba02f3e065b0d2d503236865c60e88fa4a7c7e0eae691e7e32b2d"
  head "https://github.com/nats-io/nats-server.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "741692cfc2ae1355fe20290be89747b09ca369bea409ed9e4d7df09505ff535b" => :catalina
    sha256 "4d9fa56c9f438d0dd4119285e2eeb0d49d4f30d2b419a65de72927607908fb6e" => :mojave
    sha256 "015003baad6097a8a4c62c345f87f9e8ce15811e90dac9d11384ffac0c800d5f" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"nats-server"
    prefix.install_metafiles
  end

  plist_options :manual => "nats-server"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/nats-server</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
  EOS
  end

  test do
    pid = fork do
      exec bin/"nats-server",
           "--port=8085",
           "--pid=#{testpath}/pid",
           "--log=#{testpath}/log"
    end
    sleep 3

    begin
      assert_match version.to_s, shell_output("curl localhost:8085")
      assert_predicate testpath/"log", :exist?
    ensure
      Process.kill "SIGINT", pid
      Process.wait pid
    end
  end
end
