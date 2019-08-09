class Davmail < Formula
  desc "POP/IMAP/SMTP/Caldav/Carddav/LDAP exchange gateway"
  homepage "https://davmail.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/davmail/davmail/5.3.0/davmail-5.3.0-3065.zip"
  version "5.3.0"
  sha256 "b18d6ed4a662f8b9fbf27eaec87b083ba1294fe5e0702e92f2881e3d6af1c33e"

  bottle :unneeded

  def install
    libexec.install Dir["*"]
    bin.write_jar_script libexec/"davmail.jar", "davmail", "-Djava.awt.headless=true"
  end

  plist_options :manual => "davmail"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>EnvironmentVariables</key>
        <dict>
          <key>PATH</key>
          <string>/usr/bin:/bin:/usr/sbin:/sbin:#{HOMEBREW_PREFIX}/bin</string>
        </dict>
        <key>KeepAlive</key>
        <false/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/davmail</string>
        </array>
        <key>StartInterval</key>
        <integer>300</integer>
        <key>RunAtLoad</key>
        <true />
        <key>StandardErrorPath</key>
        <string>/dev/null</string>
        <key>StandardOutPath</key>
        <string>/dev/null</string>
      </dict>
    </plist>
  EOS
  end
end
