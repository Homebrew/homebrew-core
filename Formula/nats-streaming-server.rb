class NatsStreamingServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-streaming-server/archive/v0.14.0.tar.gz"
  sha256 "9a64bda61f35e6d906e875fd63aec99b1126a3056f5410972f0f843a4e9487bc"
  head "https://github.com/nats-io/nats-streaming-server.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "63084345fd56847e8994f9d1b8f7435805fbfc060a3acabddb70d6cad6c79b34" => :mojave
    sha256 "df65a9d5b4fe8ff5ca998e0fdfe279bc18a6020ae0462151089b6f1b7b9a1679" => :high_sierra
    sha256 "b56218bfd6406c405f2cd107c77a9a9bb940cb7db0fcb61492788fb7eba0651a" => :sierra
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
