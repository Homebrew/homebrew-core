class Perkeep < Formula
  desc "Lets you permanently keep your stuff, for life"
  homepage "https://camlistore.org"
  url "https://github.com/camlistore/camlistore.git",
      :tag => "0.9",
      :revision => "7b78c50007780643798adf3fee4c84f3a10154c9"
  revision 1
  head "https://camlistore.googlesource.com/camlistore", :using => :git

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e00aa8ae64b5552c653ea1a88dc139499225185e4b2363df6260b5e6504dadef" => :high_sierra
    sha256 "4b3f55fa627f93bce045e1512945b39f5e2b49295d4a0b6097488b2d462f7a93" => :sierra
    sha256 "6af3ede34fb4ffff477b344e8d2c974df5b714d48c51ff01606eb81743083431" => :el_capitan
    sha256 "04e30799c15004110922c231e3ae28f533d73af21c6e7f4831c6845442746169" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "go" => :build

  conflicts_with "hello", :because => "both install `hello` binaries"

  def install
    system "go", "run", "make.go"
    prefix.install "bin/README"
    prefix.install "bin"
  end

  plist_options :manual => "camlistored"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <true/>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/camlistored</string>
        <string>-openbrowser=false</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
    </dict>
    </plist>
    EOS
  end

  test do
    system bin/"camget", "-version"
  end
end
