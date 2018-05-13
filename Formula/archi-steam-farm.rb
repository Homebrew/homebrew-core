class ArchiSteamFarm < Formula
  desc "ASF is a C# application that allows you to farm steam cards"
  homepage "https://github.com/JustArchi/ArchiSteamFarm"
  url "https://github.com/JustArchi/ArchiSteamFarm/releases/download/3.1.2.8/ASF-osx-x64.zip"
  version "3.1.2.8"
  sha256 "4e085a0975d7b07711acfc5d09d69a08c3ca5091c869701794a272761fcf1c27"

  bottle :unneeded

  def install
    prefix.install Dir["*"]
    etc.install prefix/"config" => "asf"
    bin.install_symlink prefix/"ArchiSteamFarm"
  end

  def post_install
    prefix.install_symlink etc/"asf" => "config"
    chmod "+x", prefix/"ArchiSteamFarm"
  end

  def caveats; <<~EOS
    Config: #{etc}/asf/
    EOS
  end

  plist_options :manual => "ArchiSteamFarm"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <false/>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_bin}/ArchiSteamFarm</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
      </dict>
    </plist>
    EOS
  end

  test do
    system "false"
  end
end
