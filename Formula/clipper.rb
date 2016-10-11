class Clipper < Formula
  desc "Share OS X clipboard with tmux and other local and remote apps"
  homepage "https://wincent.com/products/clipper"
  url "https://github.com/wincent/clipper/archive/0.3.tar.gz"
  sha256 "ddadc32477744f39a0604255c68c159613809f549c3b28bedcedd23f3f93bcf0"

  bottle do
    cellar :any_skip_relocation
    sha256 "2e136469fd301629e5efb8c5cfde53a9ff62dc5da14cb9fe1ce09b215b47ae5e" => :sierra
    sha256 "0c09f31278c101918500815d6b9c08d17806ebc40e52d04326b44a15ecce7f0c" => :el_capitan
    sha256 "907b0645aaba9805a3184bf5fea9d470bc8ec480cd666deae0f88525522a63f1" => :yosemite
    sha256 "ab8c85b76f636af8109d70ba27407bdec2e05a165746022375bf283411c9543f" => :mavericks
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
        <string>--address</string>
        <string>127.0.0.1</string>
        <string>--port</string>
        <string>8377</string>
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
end
