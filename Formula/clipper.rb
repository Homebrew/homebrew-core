class Clipper < Formula
  desc "Share macOS clipboard with tmux and other local and remote apps"
  homepage "https://wincent.com/products/clipper"
  url "https://github.com/wincent/clipper/archive/2.0.0.tar.gz"
  sha256 "9c9fa0b198d11513777d40c88e2529b2f2f84d7045a500be5946976a5cdcfe83"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "6e16549f9930f652364f727cf42ea04608d92f172e7916c85900c3b6feb98df0" => :catalina
    sha256 "2216327dbb3a341f14db9d2da767749d00e460917bcf1098665948e24eeb2e8b" => :mojave
    sha256 "a2230d8cb54b244b82ea5f5c47cebabe2f63a6b9dc1b98d47cd4a0fcd4eb743f" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"clipper", "clipper.go"
  end

  plist_options :manual => "clipper"

  def plist
    <<~EOS
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
