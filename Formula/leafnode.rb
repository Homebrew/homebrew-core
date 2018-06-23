class Leafnode < Formula
  desc "NNTP server for small sites"
  homepage "http://www.leafnode.org/"
  url "https://downloads.sourceforge.net/project/leafnode/leafnode/1.11.11/leafnode-1.11.11.tar.bz2"
  sha256 "3ec325216fb5ddcbca13746e3f4aab4b49be11616a321b25978ffd971747adc0"

  bottle :disable, "leafnode hardcodes the user at compile time with no override available."

  depends_on "pcre"

  def install
    (var/"spool/news/leafnode").mkpath
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}",
                          "--with-user=#{ENV["USER"]}", "--with-group=admin",
                          "--sysconfdir=#{etc}/leafnode", "--with-spooldir=#{var}/spool/news/leafnode"
    system "make", "install"
    (prefix/"homebrew.mxcl.fetchnews.plist").write fetchnews_plist
    (prefix/"homebrew.mxcl.texpire.plist").write texpire_plist
  end

  def caveats; <<~EOS
    For starting fetchnews and texpire, create links,
      ln -s #{opt_prefix}/homebrew.mxcl.{fetchnews,texpire}.plist ~/Library/LaunchAgents
    And to start the services,
      launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.{fetchnews,texpire}.plist
  EOS
  end

  plist_options :manual => "leafnode"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>OnDemand</key>
        <true/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>Program</key>
        <string>#{opt_sbin}/leafnode</string>
        <key>Sockets</key>
        <dict>
          <key>Listeners</key>
          <dict>
            <key>SockServiceName</key>
            <string>nntp</string>
          </dict>
        </dict>
        <key>WorkingDirectory</key>
        <string>#{var}/spool/news</string>
        <key>inetdCompatibility</key>
        <dict>
          <key>Wait</key>
          <false/>
        </dict>
      </dict>
    </plist>
  EOS
  end

  def fetchnews_plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <false/>
        <key>Label</key>
        <string>homebrew.mxcl.fetchnews</string>
        <key>Program</key>
        <string>#{opt_sbin}/fetchnews</string>
        <key>StartInterval</key>
        <integer>1800</integer>
        <key>WorkingDirectory</key>
        <string>#{var}/spool/news</string>
      </dict>
    </plist>
  EOS
  end

  def texpire_plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <false/>
        <key>Label</key>
        <string>homebrew.mxcl.texpire</string>
        <key>Program</key>
        <string>#{opt_sbin}/texpire</string>
        <key>StartInterval</key>
        <integer>25000</integer>
        <key>WorkingDirectory</key>
        <string>#{var}/spool/news</string>
      </dict>
    </plist>
  EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/leafnode-version")
  end
end
