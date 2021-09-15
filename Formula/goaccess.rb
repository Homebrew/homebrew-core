class Goaccess < Formula
  desc "Log analyzer and interactive viewer for the Apache Webserver"
  homepage "https://goaccess.io/"
  url "https://tar.goaccess.io/goaccess-1.5.1.tar.gz"
  sha256 "88417e78e62b70de3980b7622911e4fcd719c3660f003c887968e7196c39970f"
  license "MIT"
  head "https://github.com/allinurl/goaccess.git"

  livecheck do
    url "https://goaccess.io/download"
    regex(/href=.*?goaccess[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "17c731e75f74d763c6d6429a68b61a87838c60a84471713697887d80686de430"
    sha256 big_sur:       "ee16b6e3d3b2c554b0283c1542bb09642900704aee00046784cea3bf033e72b8"
    sha256 catalina:      "cb169175ffab71ec3cdacdff8c9a52f78a3331599a3e797a282180ffae3b180d"
    sha256 mojave:        "2f6832aa0c6fb0597e2cea15d9a0f2399630ebd8c8009ea249bd31da148faad7"
    sha256 x86_64_linux:  "3fb32f60f838b2da1185af1b31eb9bd2ed796939449af9970f67cb798660ac0b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext"
  depends_on "libmaxminddb"
  depends_on "tokyo-cabinet"

  def install
    ENV.append_path "PATH", Formula["gettext"].bin
    system "autoreconf", "-vfi"

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-utf8
      --enable-tcb=btree
      --enable-geoip=mmdb
      --with-libintl-prefix=#{Formula["gettext"].opt_prefix}
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"access.log").write \
      '127.0.0.1 - - [04/May/2015:15:48:17 +0200] "GET / HTTP/1.1" 200 612 "-" ' \
      '"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) ' \
      'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36"'

    output = shell_output \
      "#{bin}/goaccess --time-format=%T --date-format=%d/%b/%Y " \
      "--log-format='%h %^[%d:%t %^] \"%r\" %s %b \"%R\" \"%u\"' " \
      "-f access.log -o json 2>/dev/null"

    assert_equal "Chrome", JSON.parse(output)["browsers"]["data"].first["data"]
  end
end
