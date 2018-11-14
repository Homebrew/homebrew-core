class Goaccess < Formula
  desc "Log analyzer and interactive viewer for the Apache Webserver"
  homepage "https://goaccess.io/"
  url "https://tar.goaccess.io/goaccess-1.2.tar.gz"
  sha256 "6ba9f66540ea58fc2c17f175265f9ed76d74a8432eeac1182b74ebf4f2cd3414"
  revision 1
  head "https://github.com/allinurl/goaccess.git"

  bottle do
    sha256 "97d3bd323111361a0c0790dd9f1a3d50a96941e0c0f53d0f09bb8cea9d7c2807" => :mojave
    sha256 "fbab9c91c705da72e58919231feac0949f2a557185a884686f189d24e25d3908" => :high_sierra
    sha256 "a6dfa226d34a108be47db6ba5e1515b50b25e7ded1af71145dd43c2d6dcbd688" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libmaxminddb"
  depends_on "tokyo-cabinet"

  def install
    system "autoreconf", "-vfi"

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-utf8
      --enable-tcb=btree
      --enable-geoip=mmdb
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
