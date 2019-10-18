class Logentries < Formula
  include Language::Python::Virtualenv

  desc "Utility for access to logentries logging infrastructure"
  homepage "https://logentries.com/doc/agent/"
  url "https://github.com/rapid7/le/archive/v1.4.43.tar.gz"
  sha256 "a2ee2eeb3f2e94e9c1c58f86d0206c688cc5332921d88e48e475b54da3b3e3ef"
  revision 1
  head "https://github.com/rapid7/le.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "32a3551be64328e06a5b238650196700c800a078c68a053b1c9970303d348b24" => :catalina
    sha256 "9d674746d2d9c704030bd420d5ae4a79576b783d6177c8708b158e47d1c7c527" => :mojave
    sha256 "e741b4fd97759da0deadf1e458c7522677c1b9181d304a45c65f7d1edbefd3ff" => :high_sierra
    sha256 "65698ef238e6ba9785f2bfed470e98a8f8c6004f5a1145c679c4cbd4a8df7a50" => :sierra
    sha256 "708c87deba34989966325243046ed26daa1c3a085d7940e6266ae28b8574bee1" => :el_capitan
  end

  depends_on "python@2" # does not support Python 3

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
