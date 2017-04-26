class PureFtpd < Formula
  desc "Secure and efficient FTP server"
  homepage "https://www.pureftpd.org/"
  url "https://download.pureftpd.org/pub/pure-ftpd/releases/pure-ftpd-1.0.46.tar.gz"
  mirror "https://fossies.org/linux/misc/pure-ftpd-1.0.46.tar.gz"
  mirror "ftp://ftp.pureftpd.org/pub/pure-ftpd/releases/pure-ftpd-1.0.46.tar.gz"
  sha256 "0609807335aade4d7145abdbb5cb05c9856a3e626babe90658cb0df315cb0a5c"

  bottle do
    sha256 "4f3743bf4cbb5b60dc5711706df379b8815f9bcba6adaa2b31e30fe11b037f9b" => :sierra
    sha256 "10fbab7ef2764b2e73a0ce6cf05cbd690c2a588510e849ba9b07ad8f471e4a1d" => :el_capitan
    sha256 "124a7cfc3b61fafeb24e0d30bd1b3ed3845520172b457940c89a37481995e1d7" => :yosemite
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
