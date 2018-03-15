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
    sha256 "5a6d21ce1dd5ab518d3a44b8d8b6468470be7fe243a2baab41eb2abefabdd2d8" => :high_sierra
    sha256 "508687ae269e8a4b5c19345272809ff6e02a30b93859fe260ad47d17e23884a7" => :sierra
    sha256 "77a369395292c96ffa61ea1ad7581027d6f5febc6571ae0a188932a33ef1ac8c" => :el_capitan
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
