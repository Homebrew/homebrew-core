class NatsStreamingServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-streaming-server/archive/v0.12.0.tar.gz"
  sha256 "3041324101f17deaa6a95162ac6548ea8affc497e7008919ce88629172f095c6"
  head "https://github.com/nats-io/nats-streaming-server.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "841bf0c3e1e1f38a9b46d137c21f5dc29697f5fcae9dc2a35817d98ecbdd0a25" => :mojave
    sha256 "efa88fc0bd58b2cd2896b38ba17ba9db31b6abb7b6e52433cf1bf150b1cf9cfc" => :high_sierra
    sha256 "9227850246790f1a36ea9fe42e09d9691f1b6d21ff4ce3f8a306b25dcdcfaece" => :sierra
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
