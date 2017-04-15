# encoding: UTF-8
class Clipper < Formula
  desc "Share macOS clipboard with tmux and other local and remote apps"
  homepage "https://wincent.com/products/clipper"
  url "https://github.com/wincent/clipper/archive/0.4.2.tar.gz"
  sha256 "e707e5f9295dd793755007fdcadae63073b91e949f115d01b1a6cc6b4642cd6d"

  bottle do
    cellar :any_skip_relocation
    sha256 "a3d294b554108d9d4279c4cb7faec47bace12d809ceace2d78eb6379d64c1cf3" => :sierra
    sha256 "3544a2a3a19abac783869335f5429d7d34e709fb9487f3a5c7d6f956b7c2a561" => :el_capitan
    sha256 "8555464d08d154a85e81a10704913e63dcf7fe94fd3d055f44bbbfae3b93f27d" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "go", "build", "clipper.go"
    bin.install "clipper"
  end

  plist_options :manual => "clipper"

  def plist; <<-EOS.undent
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
