class PureFtpd < Formula
  desc "Secure and efficient FTP server"
  homepage "https://www.pureftpd.org/"
  url "https://download.pureftpd.org/pub/pure-ftpd/releases/pure-ftpd-1.0.42.tar.gz"
  mirror "ftp://ftp.pureftpd.org/pub/pure-ftpd/releases/pure-ftpd-1.0.42.tar.gz"
  sha256 "7be73a8e58b190a7054d2ae00c5e650cb9e091980420082d02ec3c3b68d8e7f9"

  bottle do
    cellar :any
    rebuild 2
    sha256 "63aa01e41750ace02f46a44c4526229cf9ded7e6837f8885e28a6bf58943618c" => :sierra
    sha256 "86d1097a53f790ed8c25dd50034d1839c63edd70d9075ffad0938db2e9c40de7" => :el_capitan
    sha256 "f97ab54d8932b289e91467fb04c158b092d33e97ca35d51f1099fa4b12991f77" => :yosemite
    sha256 "054b8d5193b19c5d296766f1b3046673400416080773bc1a559a7d8f99607d2a" => :mavericks
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
