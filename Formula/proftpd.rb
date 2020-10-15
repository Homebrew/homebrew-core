class Proftpd < Formula
  desc "Highly configurable GPL-licensed FTP server software"
  homepage "http://www.proftpd.org/"
  url "ftp://ftp.proftpd.org/distrib/source/proftpd-1.3.7a.tar.gz"
  mirror "https://fossies.org/linux/misc/proftpd-1.3.7a.tar.gz"
  mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/proftpd/proftpd-1.3.7a.tar.gz"
  sha256 "8b7bbf9757988935352d9dec5ebf96b6a1e6b63a6cdac2e93202ac6c42c4cd96"
  license "GPL-2.0"

  bottle do
    sha256 "b30ef0c9ea4f2642cb98e863c51ef8b337605ca5d9a3df8d2d9995ac00c6e9be" => :catalina
    sha256 "2f529091ef2c1e07ca1db9ec0a974f639530cca275e2f3ebbd910b42a3cb5f12" => :mojave
    sha256 "af399e07592ed468d356963c8a2b27318476dd422499ba0148d1579e4d80cd69" => :high_sierra
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

  plist_options manual: "proftpd"

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
