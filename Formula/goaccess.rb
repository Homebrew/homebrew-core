class Goaccess < Formula
  desc "Log analyzer and interactive viewer for the Apache Webserver"
  homepage "https://goaccess.io/"
  url "https://tar.goaccess.io/goaccess-1.2.tar.gz"
  sha256 "6ba9f66540ea58fc2c17f175265f9ed76d74a8432eeac1182b74ebf4f2cd3414"
  head "https://github.com/allinurl/goaccess.git"

  bottle do
    rebuild 1
    sha256 "02fb228fc96aa4d5f0d1e130428cbba4e7fd47ebfb01f7158c7ba757a1559a41" => :mojave
    sha256 "33833da9143c81fab96a7bf19452f54e94d32952f86d4a5e110c77e9854deaf9" => :high_sierra
    sha256 "7b794bcc28f24f010682e2e18d0c480cdf9d75d07b50964944f3b3fd6428972a" => :sierra
    sha256 "272e53e58e3fcd8c894285d1a90a3288edde0959a3f049bff24a6ed9180dbc3c" => :el_capitan
    sha256 "af9801407d647456b2421673aeefdc5d1bd00446d912126c8bc662cfad437937" => :yosemite
  end

  option "with-libmaxminddb", "Enable IP location information using enhanced GeoIP2 databases"

  deprecated_option "enable-geoip" => "with-libmaxminddb"
  deprecated_option "with-geoip" => "with-libmaxminddb"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "tokyo-cabinet"
  depends_on "libmaxminddb" => :optional

  def install
    system "autoreconf", "-vfi"

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-utf8
      --enable-tcb=btree
    ]

    args << "--enable-geoip=mmdb" if build.with? "libmaxminddb"

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
