class Logentries < Formula
  include Language::Python::Virtualenv

  desc "Utility for access to logentries logging infrastructure"
  homepage "https://logentries.com/doc/agent/"
  url "https://github.com/rapid7/le/archive/v1.4.43.tar.gz"
  sha256 "e0f5c18600209bfcd5c5bfae5f8f02fc78fad3a4d6185f8c432b07c4aa5956f7"
  head "https://github.com/rapid7/le.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "991c1c932c069d8ead26a4591446b4bb1f4800ef58890632fafaba636ebb3d76" => :high_sierra
    sha256 "f5b46e814f05d0cf5a98e202a49f9033c4b28ee9d43295bf88fc527135310fae" => :sierra
    sha256 "aeac2779f63a04a415ee7aecab274fa5deade682596206caf23f97d449b9d16a" => :el_capitan
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
