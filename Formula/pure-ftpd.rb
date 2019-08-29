class PureFtpd < Formula
  desc "Secure and efficient FTP server"
  homepage "https://www.pureftpd.org/"
  url "https://download.pureftpd.org/pub/pure-ftpd/releases/pure-ftpd-1.0.49.tar.gz"
  sha256 "767bf458c70b24f80c0bb7a1bbc89823399e75a0a7da141d30051a2b8cc892a5"
  revision 1

  bottle do
    cellar :any
    sha256 "207ef2785d4784e944e3bf370336d806d2349cdcd0aeb572af8fcf213477dc8a" => :mojave
    sha256 "6da126ad5fbab609e9c550b4d8a07cb218b163fd1761ef96a06ee3d7204e00ec" => :high_sierra
    sha256 "5b264d98d7ed6e2fce4ba8e7e9aafab27be763e345c8c58f29a8f755e57e403d" => :sierra
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
