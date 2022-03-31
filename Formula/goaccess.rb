class Goaccess < Formula
  desc "Log analyzer and interactive viewer for the Apache Webserver"
  homepage "https://goaccess.io/"
  url "https://tar.goaccess.io/goaccess-1.5.6.tar.gz"
  sha256 "df6585f179fdda9240f6a0e772c27b61fa1c88b3320c2409bcdfefbb4b14aabf"
  license "MIT"
  head "https://github.com/allinurl/goaccess.git", branch: "master"

  livecheck do
    url "https://goaccess.io/download"
    regex(/href=.*?goaccess[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "2a847a15962cb1f592c720ac98e72446ced4eb28a254608badfd28b7ccb91c06"
    sha256 arm64_big_sur:  "c6494ed9e36c0fb9dbae64c14a4e468962f43df7c0edc5a9a7c210d27623f3e4"
    sha256 monterey:       "a5abf25db9992321ddc71cae3048ce2b90df0e006f7a79befff5a003451e96b2"
    sha256 big_sur:        "cc55dc5526e1b9bec86a1c2139a137e1ab6f3d3ed2f0b6f27067993fefed1990"
    sha256 catalina:       "2f04a50e4f95404ac6096453ade2575ab56ceca71a0cb0bc9e7763b112eb92be"
    sha256 x86_64_linux:   "a96c5a99446ced302348bcaab79445f344f633226c272ed0f4a1d5df75bd9bae"
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
