class Goaccess < Formula
  desc "Log analyzer and interactive viewer for the Apache Webserver"
  homepage "https://goaccess.io/"
  url "https://tar.goaccess.io/goaccess-1.2.tar.gz"
  sha256 "6ba9f66540ea58fc2c17f175265f9ed76d74a8432eeac1182b74ebf4f2cd3414"
  head "https://github.com/allinurl/goaccess.git"

  bottle do
    sha256 "c52a8beb2d42ffc02d265abaa6c5aae84acd1787904735b235ea11d9e3553415" => :sierra
    sha256 "0b845a59b6fe117a60e55d7f52f46621a3465e1304a1d5e780a2f49c1c1b2b06" => :el_capitan
    sha256 "dc2a54373fb0f3db142076508ea1f7dbff30c7aa293dcb188d6f13a52337a74d" => :yosemite
  end

  option "with-geoip", "Enable IP location information using GeoIP"

  deprecated_option "enable-geoip" => "with-geoip"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "geoip" => :optional
  depends_on "tokyo-cabinet"

  def install
    system "autoreconf", "-vfi"

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-utf8
      --enable-tcb=btree
    ]

    args << "--enable-geoip" if build.with? "geoip"

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"access.log").write <<-EOS.undent
      127.0.0.1 - - [04/May/2015:15:48:17 +0200] "GET / HTTP/1.1" 200 612 "-" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36"
    EOS

    output = shell_output("#{bin}/goaccess --time-format=%T --date-format=%d/%b/%Y --log-format='%h %^[%d:%t %^] \"%r\" %s %b \"%R\" \"%u\"' -f access.log -o json 2>/dev/null")

    assert_equal "Chrome", JSON.parse(output)["browsers"]["data"][0]["data"]
  end
end
