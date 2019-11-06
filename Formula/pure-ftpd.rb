class PureFtpd < Formula
  desc "Secure and efficient FTP server"
  homepage "https://www.pureftpd.org/"
  url "https://download.pureftpd.org/pub/pure-ftpd/releases/pure-ftpd-1.0.49.tar.gz"
  sha256 "767bf458c70b24f80c0bb7a1bbc89823399e75a0a7da141d30051a2b8cc892a5"
  revision 1

  bottle do
    cellar :any
    sha256 "aa0a342b50ae3761120370fc0e6605241e03545441c472d778ef030239784454" => :catalina
    sha256 "e3a63b9af91de3c29eef40a76d7962cdf8623a8e8992aeb67bdf3948293c450d" => :mojave
    sha256 "a6a9549f3d8bde87cf01210e9fa29b403ed258246a7928d195a57f0c5ace6988" => :high_sierra
    sha256 "11dfcec52ae727128c8201a4779fc7feea1d547fe86989a621d4ba339f70de92" => :sierra
  end

  depends_on "libsodium"
  depends_on "openssl@1.1"

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
