class Clipper < Formula
  desc "Share macOS clipboard with tmux and other local and remote apps"
  homepage "https://wincent.com/products/clipper"
  url "https://github.com/wincent/clipper/archive/1.0.tar.gz"
  sha256 "f6f6aa069a941d71a4ddc33178caab1eef999c18f8c75ad379b16d97b05e3bf8"

  bottle do
    cellar :any_skip_relocation
    sha256 "fe416ac6365e397532b5c16f472a1b526cb990404582b1f0f7289bbc24338755" => :high_sierra
    sha256 "8fdbf7ebc996d137fe3fef2132c47e050b81fc8a0bb0e01d693b75d6c0e9d1b5" => :sierra
    sha256 "cbd9145484b4792f23b3da4f8da672af188ae8fbf294d20266d39a669d0a4b29" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "go", "build", "clipper.go"
    bin.install "clipper"
  end

  plist_options :manual => "clipper"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{HOMEBREW_PREFIX}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/clipper</string>
      </array>
      <key>EnvironmentVariables</key>
      <dict>
        <key>LANG</key>
        <string>en_US.UTF-8</string>
      </dict>
    </dict>
    </plist>
    EOS
  end

  test do
    TEST_DATA = "a simple string! to test clipper, with söme spéciål characters!! 🐎\n".freeze

    cmd = [opt_bin/"clipper", "-a", testpath/"clipper.sock", "-l", testpath/"clipper.log"].freeze
    ohai cmd.join " "

    require "open3"
    Open3.popen3({ "LANG" => "en_US.UTF-8" }, *cmd) do |_, _, _, clipper|
      sleep 0.5 # Give it a moment to launch and create its socket.
      begin
        sock = UNIXSocket.new testpath/"clipper.sock"
        assert_equal TEST_DATA.bytesize, sock.sendmsg(TEST_DATA)
        sock.close
        sleep 0.5
        assert_equal TEST_DATA, `LANG=en_US.UTF-8 pbpaste`
      ensure
        Process.kill "TERM", clipper.pid
      end
    end
  end
end
