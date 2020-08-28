class Coturn < Formula
  desc "Free open source implementation of TURN and STUN Server"
  homepage "https://github.com/coturn/coturn"
  url "http://turnserver.open-sys.org/downloads/v4.5.1.3/turnserver-4.5.1.3.tar.gz"
  sha256 "408bf7fde455d641bb2a23ba2df992ea0ae87b328de74e66e167ef58d8e9713a"
  license "BSD-3-Clause"

  livecheck do
    url "http://turnserver.open-sys.org/downloads/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 "027e54c623df2dca0cb5b281123a01b5ab4625d277d7a1f7ac2bd998df790b01" => :catalina
    sha256 "f5d4351c3ae9d4b8949012379f6b7cb680f4f0fdb6b01c55ff84bd735bd3a490" => :mojave
    sha256 "4bfb3e74a8d467f7935ccb316097a70b3b14018b31316bccf7c758e65f2479e8" => :high_sierra
  end

  depends_on "hiredis"
  depends_on "libevent"
  depends_on "libpq"
  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--mandir=#{man}",
                          "--localstatedir=#{var}",
                          "--includedir=#{include}",
                          "--libdir=#{lib}",
                          "--docdir=#{doc}",
                          "--prefix=#{prefix}"

    system "make", "install"

    man.mkpath
    man1.install Dir["man/man1/*"]
  end

  plist_options manual: "turnserver -c #{HOMEBREW_PREFIX}/etc/turnserver.conf --userdb=#{HOMEBREW_PREFIX}/opt/coturn/var/db/turndb --daemon"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>KeepAlive</key>
          <dict>
            <key>SuccessfulExit</key>
            <false/>
          </dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/turnserver</string>
            <string>-c</string>
            <string>#{etc}/turnserver.conf</string>
          </array>
          <key>WorkingDirectory</key>
          <string>#{HOMEBREW_PREFIX}</string>
          <key>RunAtLoad</key>
          <true/>
          <key>StandardErrorPath</key>
          <string>#{var}/log/coturn.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/coturn.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    system "#{bin}/turnadmin", "-l"
  end
end
