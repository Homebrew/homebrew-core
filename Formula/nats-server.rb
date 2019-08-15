class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/v2.0.4.tar.gz"
  sha256 "8021e5678867ac1ce28487ddbb8a048ef74813c6fbc4a99589096a1f46f5e351"
  head "https://github.com/nats-io/nats-server.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "834934be04c7457e3902ecc15936625804c3fa38436d6474053c9b7d30d4a926" => :mojave
    sha256 "7b9b68119514108ccf3ff191282b9c7658851d9835e64e65995d10cba6c4cee7" => :high_sierra
    sha256 "8e9a079114df8632b57958b5db1bfe4a5db6c8a267e6fa4756a5ae5db54579e3" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "off"
    mkdir_p "src/github.com/nats-io"
    ln_s buildpath, "src/github.com/nats-io/nats-server"
    buildfile = buildpath/"src/github.com/nats-io/nats-server/main.go"
    system "go", "build", "-v", "-o", bin/"nats-server", buildfile
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
