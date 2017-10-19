class PureFtpd < Formula
  desc "Secure and efficient FTP server"
  homepage "https://www.pureftpd.org/"
  url "https://download.pureftpd.org/pub/pure-ftpd/releases/pure-ftpd-1.0.46.tar.gz"
  mirror "https://fossies.org/linux/misc/pure-ftpd-1.0.46.tar.gz"
  mirror "https://ftp.pureftpd.org/pub/pure-ftpd/releases/pure-ftpd-1.0.46.tar.gz"
  sha256 "0609807335aade4d7145abdbb5cb05c9856a3e626babe90658cb0df315cb0a5c"
  revision 1

  bottle do
    sha256 "def15854f9eea616cfb9b22d003b44d6302f2115df8ee8b682f67431a3048e78" => :high_sierra
    sha256 "64d935c2a271f301b095eefbdd78d103a20e21842d2d1bc800c47d4646d983b8" => :sierra
    sha256 "e1dc733cce0594ae92ebba708673f64e4c88f01d11ce9cc04ba318e04db395a4" => :el_capitan
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
