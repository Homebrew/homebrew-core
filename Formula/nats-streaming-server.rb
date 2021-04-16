class NatsStreamingServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-streaming-server/archive/refs/tags/v0.21.2.tar.gz"
  sha256 "4e116cd50e92eb72583db654d083e993a4f217a2096ddb9c56eff561ca5b90ad"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-streaming-server.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f1a1bc8fb1115c7a80cb58589aa7f396cad4bf45d73d4c66b7c05046e75c773a"
    sha256 cellar: :any_skip_relocation, big_sur:       "93168f5dc5e6ec97cbd5caa4d32a5d8a3c68a980ce99bc4db12d65dae7347cd1"
    sha256 cellar: :any_skip_relocation, catalina:      "38150554defd811c8292a2ff938293f00e508c98e23a71a4ce9e6d8a29c1fda6"
    sha256 cellar: :any_skip_relocation, mojave:        "9143966d65c08b32b2a66673ece12a560394019b81ae45ebe3db13d74ce5d477"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"nats-streaming-server"
    prefix.install_metafiles
  end

  plist_options manual: "nats-streaming-server"

  def plist
    <<~EOS
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
