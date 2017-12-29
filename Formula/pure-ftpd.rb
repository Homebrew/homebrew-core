class PureFtpd < Formula
  desc "Secure and efficient FTP server"
  homepage "https://www.pureftpd.org/"
  url "https://download.pureftpd.org/pub/pure-ftpd/releases/pure-ftpd-1.0.47.tar.gz"
  sha256 "4740c316f5df879a2d68464489fb9b8b90113fe7dce58e2cdd2054a4768f27ad"

  bottle do
    sha256 "3ee0ae276bad11f6459e2a866f96f7618a12b8625e69dd1d2b3fbcb3c7f3d3fe" => :high_sierra
    sha256 "fcde5497abd815c560b9b8dc1bcb40d1018e378e16fcbc04cb942d244a64c972" => :sierra
    sha256 "db8752838fcba745378a65f79c40ee8e573f50cd648d48b23b47b813dfb5cba1" => :el_capitan
  end

  option "with-virtualchroot", "Follow symbolic links even for chrooted accounts"

  depends_on "libsodium"
  depends_on "openssl"
  depends_on :postgresql => :optional
  depends_on "mysql" => :optional

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
      --sysconfdir=#{etc}
      --with-everything
      --with-pam
      --with-tls
      --with-bonjour
    ]

    args << "--with-pgsql" if build.with? "postgresql"
    args << "--with-mysql" if build.with? "mysql"
    args << "--with-virtualchroot" if build.with? "virtualchroot"

    system "./configure", *args
    system "make", "install"
  end

  plist_options :manual => "pure-ftpd"

  def plist; <<~EOS
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
          <string>#{opt_sbin}/pure-ftpd</string>
          <string>--chrooteveryone</string>
          <string>--createhomedir</string>
          <string>--allowdotfiles</string>
          <string>--login=puredb:#{etc}/pureftpd.pdb</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/pure-ftpd.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/pure-ftpd.log</string>
      </dict>
    </plist>
    EOS
  end

  test do
    system bin/"pure-pw", "--help"
  end
end
