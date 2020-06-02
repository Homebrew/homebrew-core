class Coturn < Formula
  desc "Free open source implementation of TURN and STUN Server"
  homepage "https://github.com/coturn/coturn"
  url "http://turnserver.open-sys.org/downloads/v4.5.1.2/turnserver-4.5.1.2.tar.gz"
  sha256 "5f34ded2c2871c74d498712c3fbfce8a418f8ea8e6508adc07cfe5e152881455"
  revision 1

  bottle do
    sha256 "9f00d9739c200fad1363e0290ea1c07320da8c960fab8c93e1a299c58ba52242" => :catalina
    sha256 "b8021791ebdd945f3d5aa6c2e31d4a55a24137b5759c6cd64b7da569843a05f3" => :mojave
    sha256 "35f3504a39e5c58c3cc81c0f1d544f5a2e28c6c651281c54b8a98f096b0332aa" => :high_sierra
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

  plist_options :manual => "turnserver -c #{HOMEBREW_PREFIX}/etc/turnserver.conf --userdb=#{HOMEBREW_PREFIX}/opt/coturn/var/db/turndb --daemon"

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
