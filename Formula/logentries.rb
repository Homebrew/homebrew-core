class Logentries < Formula
  include Language::Python::Virtualenv

  desc "Utility for access to logentries logging infrastructure"
  homepage "https://logentries.com/doc/agent/"
  url "https://github.com/rapid7/le/archive/v1.4.43.tar.gz"
  sha256 "e0f5c18600209bfcd5c5bfae5f8f02fc78fad3a4d6185f8c432b07c4aa5956f7"
  head "https://github.com/rapid7/le.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "76338a8179b342a815cc03c2a074b6bc2fcc1dbea309d676e33e0a9ce659760d" => :high_sierra
    sha256 "bf29b4ac8bba11425b5a06ce68568c60f83cc0676927b967cb8d9c41995df60d" => :sierra
    sha256 "231eb13cd13914785b8b09f63e0758201ae7e36ad57cf6c847e0f9effc25b556" => :el_capitan
  end

  depends_on "python@2"

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
