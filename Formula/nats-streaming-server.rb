class NatsStreamingServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-streaming-server/archive/v0.21.1.tar.gz"
  sha256 "69dc0d80d4e494f63b8110cfbd779c3c58f4e4af2c27eb87b8cc8599e43859c9"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-streaming-server.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9bea1d42813ee990f4911c5913bd7737760942e9edc2cbf6acbdad42905c6432"
    sha256 cellar: :any_skip_relocation, big_sur:       "57861dee4e2a16812e996a3514b0181f287b25cc07444a12e35e045a1a37c80e"
    sha256 cellar: :any_skip_relocation, catalina:      "b5b5fcfb985941aa21d1fe9fac9a8817e02a512aef118b7e9f41a783f3c600dc"
    sha256 cellar: :any_skip_relocation, mojave:        "6c4ca896ea015a1ebd530a00a6f99e23d5364693a5c23eb6309e7c341b83fdac"
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
