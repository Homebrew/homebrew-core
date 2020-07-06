class Goaccess < Formula
  desc "Log analyzer and interactive viewer for the Apache Webserver"
  homepage "https://goaccess.io/"
  url "https://tar.goaccess.io/goaccess-1.4.tar.gz"
  sha256 "e8fbb9ff852556d72dfd9f1d0134ba075ce5b4c41289902a6f4e0d97c69377be"
  license "MIT"
  head "https://github.com/allinurl/goaccess.git"

  bottle do
    sha256 "ca26b40fa6af07692cef8397e8b5cef4a4426f413cea4d08399bf2e075656f70" => :catalina
    sha256 "ff8280daf00ff222480c70ab73762a74f1661053f68f318b48c934b91215d80c" => :mojave
    sha256 "fb4fd174c742537f1cbf536ca36a5cfd0580ae0576cfe484dc6848daea208953" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext"
  depends_on "libmaxminddb"
  depends_on "tokyo-cabinet"

  def install
    ENV.append_path "PATH", Formula["gettext"].bin
    system "autoreconf", "-vfi"

    # upstream issue: https://github.com/allinurl/goaccess/issues/1779
    inreplace "src/parser.c", "#include <malloc.h>", ""

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
