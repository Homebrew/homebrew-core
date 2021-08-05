class NatsStreamingServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-streaming-server/archive/refs/tags/v0.22.1.tar.gz"
  sha256 "116035f0c3c7e6154b7b1352d53ab16bd90b89afbce4afb70fe5d686ca4f24b0"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-streaming-server.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "39b3c159d546f81777c33d8789685158c969450da3a0d3a2d9dbf4e17af4248a"
    sha256 cellar: :any_skip_relocation, big_sur:       "0e34dac4cecf758e1e948227e72ddda767a6e018f54ae20b2263dd2c700da459"
    sha256 cellar: :any_skip_relocation, catalina:      "972fdaccee5d7d1990da81656c332f7bb3791189cf537bc7f4f3259702675195"
    sha256 cellar: :any_skip_relocation, mojave:        "681bd8f03835321dbe72c54cdcbab294d4bb5328f62ddcbb3dd75cf5026171d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1c1d00090e426ec88a33de2e8dd8f77b225e15baabc4e21f3f6e8e0d6b0a5a2"
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
