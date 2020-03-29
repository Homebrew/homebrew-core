class Derby < Formula
  desc "Apache Derby is an embedded relational database running on JVM"
  homepage "https://db.apache.org/derby/"
  url "https://www.apache.org/dyn/closer.lua?path=db/derby/db-derby-10.15.2.0/db-derby-10.15.2.0-bin.tar.gz"
  mirror "https://archive.apache.org/dist/db/derby/db-derby-10.15.2.0/db-derby-10.15.2.0-bin.tar.gz"
  sha256 "ac51246a2d9eef70cecd6562075b30aa9953f622cbd2cd3551bc3d239dc6f02a"

  bottle :unneeded

  depends_on "openjdk"

  def install
    rm_rf Dir["bin/*.bat"]
    libexec.install %w[lib test index.html LICENSE NOTICE RELEASE-NOTES.html
                       KEYS docs javadoc demo]
    bin.install Dir["bin/*"]
    bin.env_script_all_files libexec/"bin",
                             :JAVA_HOME     => Formula["openjdk"].opt_prefix,
                             :DERBY_INSTALL => libexec,
                             :DERBY_HOME    => libexec
  end

  def post_install
    (var/"derby").mkpath
  end

  plist_options :manual => "DERBY_OPTS=-Dsystem.derby.home=#{HOMEBREW_PREFIX}/var/derby #{HOMEBREW_PREFIX}/bin/startNetworkServer"

  def plist
    <<~EOS
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
    assert_match "libexec/lib/derby.jar] #{version}",
                 shell_output("#{bin}/sysinfo")

    pid = fork do
      exec "#{bin}/startNetworkServer"
    end

    begin
      sleep 12
      exec "#{bin}/stopNetworkServer"
    ensure
      Process.wait(pid)
    end
  end
end
