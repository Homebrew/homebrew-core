class NatsStreamingServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-streaming-server/archive/v0.21.1.tar.gz"
  sha256 "69dc0d80d4e494f63b8110cfbd779c3c58f4e4af2c27eb87b8cc8599e43859c9"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-streaming-server.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2231ef6bea67f02148ccf57c244bcafcadeee0a67e2d4ba3ac10a157ba5fb3ae"
    sha256 cellar: :any_skip_relocation, big_sur:       "7b566296fd02004932643b2155b5ce5942d099ae1313297b785edbb36c43e3e0"
    sha256 cellar: :any_skip_relocation, catalina:      "b8751cfead6041112c3dc550a21b0accdab3c3e605c100a34c5c99c45350fbae"
    sha256 cellar: :any_skip_relocation, mojave:        "e4366b1b27a50eeda6027513248897b406d6ae266e7da66e7872dec422ec1177"
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
