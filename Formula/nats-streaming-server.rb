class NatsStreamingServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-streaming-server/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "adbb4a51536f9baabf42788c9e87bef029bc861cc5376e679098f2bc2dce181e"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-streaming-server.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3d4602a3cda6e52f30f19b7f2f77fa7ba991b2f8823c81ca0babb753d74609b3"
    sha256 cellar: :any_skip_relocation, big_sur:       "9ddcbd4a6828e27b1a95e72c60459c984504457fd91e9bfb421eb65a31d66706"
    sha256 cellar: :any_skip_relocation, catalina:      "8338994ba6e7900bd7c1a7037a7c83cac35b79ce5c1090ce62aba1c22b65c493"
    sha256 cellar: :any_skip_relocation, mojave:        "0ab63e58ea6d7130a687b38c1d67f2917121828ec75605d8a7f06ab1db471638"
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
