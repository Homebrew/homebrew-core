class PureFtpd < Formula
  desc "Secure and efficient FTP server"
  homepage "https://www.pureftpd.org/"
  url "https://download.pureftpd.org/pub/pure-ftpd/releases/pure-ftpd-1.0.46.tar.gz"
  mirror "https://fossies.org/linux/misc/pure-ftpd-1.0.46.tar.gz"
  mirror "ftp://ftp.pureftpd.org/pub/pure-ftpd/releases/pure-ftpd-1.0.46.tar.gz"
  sha256 "0609807335aade4d7145abdbb5cb05c9856a3e626babe90658cb0df315cb0a5c"

  bottle do
    sha256 "cb6e0e3bf30f7adbed8b2a39c95e8656eaa1b2d81672aca1c200b8c37e399f48" => :sierra
    sha256 "50c1b92540ecb9b99a34c57b03fdab13d581c4b05d31f405d67ac2a9e5f45528" => :el_capitan
    sha256 "108a3d878df5f0258a7ecbfd63004c844b4d621c4cbf2e4bcd5eb5ffd4a5ff7d" => :yosemite
  end

  option "with-virtualchroot", "Follow symbolic links even for chrooted accounts"

  depends_on "libsodium"
  depends_on "openssl"
  depends_on :postgresql => :optional
  depends_on :mysql => :optional

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
          <string>#{opt_sbin}/pure-ftpd</string>
          <string>-A -j -z</string>
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
