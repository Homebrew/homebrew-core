class Clipper < Formula
  desc "Share macOS clipboard with tmux and other local and remote apps"
  homepage "https://wincent.com/products/clipper"
  url "https://github.com/wincent/clipper/archive/2.0.0.tar.gz"
  sha256 "9c9fa0b198d11513777d40c88e2529b2f2f84d7045a500be5946976a5cdcfe83"

  bottle do
    cellar :any_skip_relocation
    sha256 "915eb7a292f99d512a41e29bc155fd157e6387418c1628287d7b5e56c30ac4f6" => :catalina
    sha256 "ba99d879f6edccf9555855897bcc8b029b46ae5866bba052c3f826eaaa6cc717" => :mojave
    sha256 "918667f51ab58ce6518c3777d42d3cabb9323d14fbcf805a55b1fb7952cfe05e" => :high_sierra
    sha256 "e3c2f97b33d9e2648cd4efe1ede9e9d427d0cd71778891324a4def3b4f98562a" => :sierra
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
