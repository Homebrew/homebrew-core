class Clipper < Formula
  desc "Share macOS clipboard with tmux and other local and remote apps"
  homepage "https://wincent.com/products/clipper"
  url "https://github.com/wincent/clipper/archive/0.3.tar.gz"
  sha256 "ddadc32477744f39a0604255c68c159613809f549c3b28bedcedd23f3f93bcf0"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "9dd51dbb7c3834c99bcd8c496dbd07831b0a180d03e5696d02606b601945029b" => :sierra
    sha256 "d8cb0cf54d7c07e1adf527edb351e9fa47736432e99ea6dcfed9b4239d853448" => :el_capitan
    sha256 "454c13885a8b0bff59efebf64aa7708b2428bdc6a3a94bf6adbcb9a139aba730" => :yosemite
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
end
