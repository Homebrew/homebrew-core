class Logentries < Formula
  include Language::Python::Virtualenv

  desc "Utility for access to logentries logging infrastructure"
  homepage "https://logentries.com/doc/agent/"
  url "https://github.com/logentries/le/archive/v1.4.42.tar.gz"
  sha256 "52e4bfb61753a2fe9f83232e9cefe1aa9ebb87899572f070bad7293e1d891bf9"
  head "https://github.com/logentries/le.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4e7c650c278735f2f7aa720bfe3d2b2bb59c685eab1a64920a70bbe53ea73dac" => :high_sierra
    sha256 "e97d41a863d4692549bd23a9e1e2d01d6255a583b0a25cdd97aaf130e12ef276" => :sierra
    sha256 "97c9c05730ea6abde47fd6ab054e73510d24db0541cc9394b687bafed1650f72" => :el_capitan
    sha256 "f61a6ead7bddbedd902216a3210cd23d5ecf7e1bf941c1dee4e59a4dde4479d9" => :yosemite
  end

  conflicts_with "le", :because => "both install a le binary"

  def install
    virtualenv_install_with_resources
  end

  plist_options :manual => "le monitor"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
        <string>#{opt_bin}/le</string>
        <string>monitor</string>
        </array>
        <key>KeepAlive</key>
        <true/>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
    EOS
  end

  test do
    shell_output("#{bin}/le --help", 4)
  end
end
