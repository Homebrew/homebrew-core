class H2 < Formula
  desc "Java SQL database"
  homepage "https://www.h2database.com/"
  url "https://www.h2database.com/h2-2019-10-14.zip"
  version "1.4.200"
  sha256 "a72f319f1b5347a6ee9eba42718e69e2ae41e2f846b3475f9292f1e3beb59b01"

  bottle :unneeded

  def script; <<~EOS
    #!/bin/sh
    cd #{libexec} && bin/h2.sh "$@"
  EOS
  end

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]

    # As of 1.4.190, the script contains \r\n line endings,
    # causing it to fail on macOS. This is a workaround until
    # upstream publishes a fix.
    #
    # https://github.com/h2database/h2database/issues/218
    h2_script = File.read("bin/h2.sh").gsub("\r\n", "\n")
    File.open("bin/h2.sh", "w") { |f| f.write h2_script }

    # Fix the permissions on the script
    chmod 0755, "bin/h2.sh"

    libexec.install Dir["*"]
    (bin+"h2").write script
  end

  plist_options :manual => "h2"

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
            <string>#{opt_bin}/h2</string>
            <string>-tcp</string>
            <string>-web</string>
            <string>-pg</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
      </dict>
    </plist>
  EOS
  end

  test do
    assert_match "Usage: java org.h2.tools.GUIConsole", shell_output("#{bin}/h2 -help 2>&1")
  end
end
