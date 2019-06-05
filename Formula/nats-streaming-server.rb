class NatsStreamingServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-streaming-server/archive/v0.15.1.tar.gz"
  sha256 "d2c2fba9efb7a0c6c2706a2ec1ccd19cb8b3dc0441cb35c71d851d60917f5091"
  head "https://github.com/nats-io/nats-streaming-server.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ee6dd6b1bef11441efbddc49a4d2a868fd58f3ff8ed0ff1c3a861abf52a621b9" => :mojave
    sha256 "155922f1d7b5eda7780021ae418d1c5dc12f5be54453d79ddbebc10d351e47ea" => :high_sierra
    sha256 "e02ec67d3eccc9633ad6a8f846b5fcf10dfe0c185f924f87f32bb11f99863ef6" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "off"
    mkdir_p "src/github.com/nats-io"
    ln_s buildpath, "src/github.com/nats-io/nats-streaming-server"
    buildfile = buildpath/"src/github.com/nats-io/nats-streaming-server/nats-streaming-server.go"
    system "go", "build", "-v", "-o", bin/"nats-streaming-server", buildfile
  end

  plist_options :manual => "nats-streaming-server"

  def plist; <<~EOS
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
      assert_predicate testpath/"log", :exist?
      assert_match version.to_s, File.read(testpath/"log")
    ensure
      Process.kill "SIGINT", pid
      Process.wait pid
    end
  end
end
