class Goaccess < Formula
  desc "Log analyzer and interactive viewer for the Apache Webserver"
  homepage "https://goaccess.io/"
  url "https://tar.goaccess.io/goaccess-1.4.tar.gz"
  sha256 "e8fbb9ff852556d72dfd9f1d0134ba075ce5b4c41289902a6f4e0d97c69377be"
  head "https://github.com/allinurl/goaccess.git"

  bottle do
    sha256 "9c305445bc22da2f3d8ad97ccdcb7add64c2afd324377657851b313be75e0680" => :catalina
    sha256 "1e6c45b187083c3e39a477309439cfec74e8a255ac83e7f444d26fb707f0654f" => :mojave
    sha256 "724e69d15a0b7736af661e69a4a7b247489ecd53cd8b26d64d8ed591aeea69bc" => :high_sierra
    sha256 "8c120ad2ff8e1f105b7cdb0812e5613ec6abec8f75d27260b21a1dfc913036a8" => :sierra
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
