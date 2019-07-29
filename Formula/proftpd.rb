class Proftpd < Formula
  desc "Highly configurable GPL-licensed FTP server software"
  homepage "http://www.proftpd.org/"
  url "ftp://ftp.proftpd.org/distrib/source/proftpd-1.3.6.tar.gz"
  mirror "https://fossies.org/linux/misc/proftpd-1.3.6.tar.gz"
  mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/proftpd/proftpd-1.3.6.tar.gz"
  sha256 "91ef74b143495d5ff97c4d4770c6804072a8c8eb1ad1ecc8cc541b40e152ecaf"
  revision 1

  bottle do
    sha256 "d8e913133feffb5e1e669991f345ca04e014501833af51cc67527d99a53b72df" => :mojave
    sha256 "654875de19ba33e14985e88c24fbd54a27877966cb26177bfbffd89286a2f2b2" => :high_sierra
    sha256 "5bbb5075bd0e1091feb88f5a57172d2c5ee1e31caa5c5f6e92009f7da1cffcce" => :sierra
  end

  # Patch CVE-2019-12815. The fix for this CVE did not result in a new release.
  # This patch has been backported into the 1.3.6 branch. Remove patch on next release.
  # Additional information:
  # https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2019-12815
  # http://bugs.proftpd.org/show_bug.cgi?id=4372
  # https://github.com/proftpd/proftpd/pull/816
  patch do
    url "https://github.com/proftpd/proftpd/commit/d19dd64161936d70c0a1544bd2c8e90850f4b7ae.patch?full_index=1"
    sha256 "c4c54a0dec446ee940dc1267e64d502374e0735355005bbfe67c46bdb12d203a"
  end

  def install
    # fixes unknown group 'nogroup'
    # http://www.proftpd.org/docs/faq/linked/faq-ch4.html#AEN434
    inreplace "sample-configurations/basic.conf", "nogroup", "nobody"

    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}"
    ENV.deparallelize
    install_user = ENV["USER"]
    install_group = `groups`.split[0]
    system "make", "INSTALL_USER=#{install_user}", "INSTALL_GROUP=#{install_group}", "install"
  end

  plist_options :manual => "proftpd"

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
          <string>#{opt_sbin}/proftpd</string>
        </array>
        <key>UserName</key>
        <string>root</string>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
        <key>StandardErrorPath</key>
        <string>/dev/null</string>
        <key>StandardOutPath</key>
        <string>/dev/null</string>
      </dict>
    </plist>
  EOS
  end

  test do
    assert_match version.to_s, shell_output("#{opt_sbin}/proftpd -v")
  end
end
