class Proftpd < Formula
  desc "Highly configurable GPL-licensed FTP server software"
  homepage "http://www.proftpd.org/"
  url "ftp://ftp.proftpd.org/distrib/source/proftpd-1.3.6d.tar.gz"
  mirror "https://fossies.org/linux/misc/proftpd-1.3.6d.tar.gz"
  mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/proftpd/proftpd-1.3.6d.tar.gz"
  sha256 "c338e2e25d1b6f51d397af154a0124fc42eee6b7ff99a2d976777d6b2f97c096"

  bottle do
    sha256 "64921070d5fec1b23e70f1f94083278005c3075e60064e2bb6842837a5f47f70" => :catalina
    sha256 "c1152fa9b77042914ba1c3d80cc365058d0c497ff817d5f3028e4b61ee7fd5aa" => :mojave
    sha256 "1168e663193462a081b1f19cf9813ee007b80ed22187f2b81e3c8eaa84536d42" => :high_sierra
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

  def plist
    <<~EOS
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
