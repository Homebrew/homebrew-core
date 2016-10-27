class Noclamshell < Formula
  desc "Disable closed-clamshell mode"
  homepage "https://github.com/pirj/noclamshell"
  url "https://github.com/pirj/noclamshell/archive/1.0.tar.gz"
  sha256 "eb74ebcb7ff6019fef32ecd53d07f570a77f3084a83c0f2942359e9da92e9398"

  def install
    sbin.install "noclamshell"
  end

  plist_options :manual => "noclamshell"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{sbin}/noclamshell</string>
        </array>
        <key>KeepAlive</key>
        <true/>
        <key>RunAtLoad</key>
        <true/>
        <key>StandardErrorPath</key>
        <string>/dev/null</string>
        <key>StandardOutPath</key>
        <string>/dev/null</string>
      </dict>
    </plist>
    EOS
  end

  test do
    system <<-EOS.undent
      alias pmset='touch sleeping'
      alias ioreg='echo AppleClamshellState = No'
      source #{sbin}/noclamshell &
      sleep 3
      cat sleeping && exit 1
      kill $!
      alias ioreg='echo AppleClamshellState = Yes'
      source #{sbin}/noclamshell &
      sleep 3
      cat sleeping || exit 1
      kill $!
      true
    EOS
  end
end
