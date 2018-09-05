class Privoxy < Formula
  desc "Advanced filtering web proxy"
  homepage "https://www.privoxy.org/"
  url "https://downloads.sourceforge.net/project/ijbswa/Sources/3.0.26%20%28stable%29/privoxy-3.0.26-stable-src.tar.gz"
  sha256 "57e415b43ee5dfdca74685cc034053eaae962952fdabd086171551a86abf9cd8"

  bottle do
    cellar :any
    rebuild 1
    sha256 "89c7bd4cfc6bce1cdcae9d05bac4a316ec03a32b8ff23640d44b4f76f9a83e5f" => :mojave
    sha256 "6d73d0568bf02dc31bce3e87a92ed8a90c67d19340ecbc2d22102522dc12a74b" => :high_sierra
    sha256 "bd606ba22bca049b7f0457cdfa846aefa09eaf2c9d1e18ff3584254e1fc05048" => :sierra
    sha256 "4aa50d19fa164c7bb5b6a14f5ef562fb9b40acebe8575cd5af4dffac78fa3400" => :el_capitan
    sha256 "8a0e661df5d221ae65b6367791a923d1f2b769b0206b3fb50c1e6a84f2830d7b" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pcre"

  def install
    # Find Homebrew's libpcre
    ENV.append "LDFLAGS", "-L#{HOMEBREW_PREFIX}/lib"

    # No configure script is shipped with the source
    system "autoreconf", "-i"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}/privoxy",
                          "--localstatedir=#{var}"
    system "make"
    system "make", "install"
  end

  plist_options :manual => "privoxy #{HOMEBREW_PREFIX}/etc/privoxy/config"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <true/>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>WorkingDirectory</key>
      <string>#{var}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{sbin}/privoxy</string>
        <string>--no-daemon</string>
        <string>#{etc}/privoxy/config</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>StandardErrorPath</key>
      <string>#{var}/log/privoxy/logfile</string>
    </dict>
    </plist>
  EOS
  end

  test do
    bind_address = "127.0.0.1:8118"
    (testpath/"config").write("listen-address #{bind_address}\n")
    begin
      server = IO.popen("#{sbin}/privoxy --no-daemon #{testpath}/config")
      sleep 1
      assert_match "200 OK", shell_output("/usr/bin/curl -I -x #{bind_address} https://github.com")
    ensure
      Process.kill("SIGINT", server.pid)
      Process.wait(server.pid)
    end
  end
end
