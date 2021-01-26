class Coturn < Formula
  desc "Free open source implementation of TURN and STUN Server"
  homepage "https://github.com/coturn/coturn"
  url "http://turnserver.open-sys.org/downloads/v4.5.2/turnserver-4.5.2.tar.gz"
  sha256 "1cbef88cd4ab0de0d4d7011f4e7eaf39a344b485e9a272f3055eb53dd303b6e1"
  license "BSD-3-Clause"

  livecheck do
    url "http://turnserver.open-sys.org/downloads/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    rebuild 1
    sha256 "83258540358e8a1b03e504eca1494841efaf5ff3d8d2bab21be3889fec3b1b53" => :big_sur
    sha256 "9de50fb73d1af5224a577444d395fdc77395a7fbc42010a8dfb8cb40d2b5078e" => :arm64_big_sur
    sha256 "62ad808fb17756704e5fbec7f1f6acb7246545e27b05cf537ab3a716c0fcbec7" => :catalina
    sha256 "e9601d4fca70c049a01145aee4f09aac8efad87d73de706dd3ea580f6be7e875" => :mojave
  end

  depends_on "pkg-config" => :build
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
