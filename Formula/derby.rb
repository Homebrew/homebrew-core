class Derby < Formula
  desc "Apache Derby is an embedded relational database running on JVM"
  homepage "https://db.apache.org/derby/"
  url "https://www.apache.org/dyn/closer.cgi?path=db/derby/db-derby-10.12.1.1/db-derby-10.12.1.1-bin.tar.gz"
  mirror "https://archive.apache.org/dist/db/derby/db-derby-10.12.1.1/db-derby-10.12.1.1-bin.tar.gz"
  sha256 "d233b3f26f652226429c3d2f094f129afc3c3bd6435543e5aeb4a256f95085a8"

  bottle :unneeded

  depends_on :java => "1.6+"

  def install
    rm_rf Dir["bin/*.bat"]
    libexec.install %w[lib test index.html LICENSE NOTICE RELEASE-NOTES.html KEYS docs javadoc demo]
    bin.install Dir["bin/*"]
    bin.env_script_all_files(libexec/"bin",
      Language::Java.overridable_java_home_env.merge(:DERBY_INSTALL => libexec.to_s, :DERBY_HOME => libexec.to_s))
  end

  def post_install
    (var/"derby").mkpath
  end

  plist_options :manual => "DERBY_OPTS=-Dsystem.derby.home=#{HOMEBREW_PREFIX}/var/derby #{HOMEBREW_PREFIX}/bin/startNetworkServer"

  def plist; <<-EOS.undent
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
        <string>#{opt_bin}/NetworkServerControl</string>
        <string>-h</string>
        <string>127.0.0.1</string>
        <string>start</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{var}/derby</string>
    </dict>
    </plist>
    EOS
  end

  test do
    assert_match /OS name:         macOS/, shell_output("#{bin}/sysinfo")

    pid = fork do
      exec "#{bin}/startNetworkServer"
    end

    begin
      sleep 4
      exec "#{bin}/stopNetworkServer"
    ensure
      Process.wait(pid)
    end
  end
end
