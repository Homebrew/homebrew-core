class NatsStreamingServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-streaming-server/archive/v0.4.0.tar.gz"
  sha256 "8d0c4169fc07798d1427a1d0d2248f7ae4b54366f029b3c75edf537170937c13"
  head "https://github.com/nats-io/nats-streaming-server.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9f29823ab7a049733f87d974821d5873d581e17c7de0649b23e620023d66f571" => :sierra
    sha256 "e8a1005faecfc588b2934ef1a35ec5c015d6be8c764f308b27e75169ad19adcd" => :el_capitan
    sha256 "a171e67d86dbe8b1ed6b652b1b2b0ff5263d8f746a54eeb81ed951424abdb40e" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p "src/github.com/nats-io"
    ln_s buildpath, "src/github.com/nats-io/nats-streaming-server"
    buildfile = buildpath/"src/github.com/nats-io/nats-streaming-server/nats-streaming-server.go"
    system "go", "build", "-v", "-o", bin/"nats-streaming-server", buildfile
  end

  plist_options :manual => "nats-streaming-server"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/nats-streaming-server</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
    EOS
  end

  test do
    pid = fork do
      exec "#{bin}/nats-streaming-server --port=8085 --pid=#{testpath}/pid --log=#{testpath}/log"
    end
    sleep 3

    begin
      assert_match "INFO", shell_output("curl localhost:8085")
      assert File.exist?(testpath/"log")
      assert_match version.to_s, File.read(testpath/"log")
    ensure
      Process.kill "SIGINT", pid
      Process.wait pid
    end
  end
end
