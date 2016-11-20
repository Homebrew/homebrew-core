class Goaccess < Formula
  desc "Log analyzer and interactive viewer for the Apache Webserver"
  homepage "https://goaccess.io/"
  url "http://tar.goaccess.io/goaccess-1.1.tar.gz"
  sha256 "8f50004f3511561c072ca907549ead564bc0bdcd8829d4a3703a62cf5b38cfa1"
  head "https://github.com/allinurl/goaccess.git"

  bottle do
    sha256 "a6bdf74a437da0f4a40f54513533b32436405ab7d216bd055d2cee324f3f6901" => :sierra
    sha256 "bc4f94c2e756518ac67487fc3c71b65627191d2182736cb8eed1bce1c87d5a13" => :el_capitan
    sha256 "dc73e32b34800461374d380e8ca3ed716a084ab1d7eecee1beee6b0bcbb9e84f" => :yosemite
  end

  option "with-geoip", "Enable IP location information using GeoIP"

  deprecated_option "enable-geoip" => "with-geoip"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "geoip" => :optional

  def install
    system "autoreconf", "-vfi"

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-utf8
    ]

    args << "--enable-geoip" if build.with? "geoip"

    system "./configure", *args
    system "make", "install"
  end

  test do
    require "utils/json"

    (testpath/"access.log").write <<-EOS.undent
      127.0.0.1 - - [04/May/2015:15:48:17 +0200] "GET / HTTP/1.1" 200 612 "-" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36"
    EOS

    output = shell_output("#{bin}/goaccess --time-format=%T --date-format=%d/%b/%Y --log-format='%h %^[%d:%t %^] \"%r\" %s %b \"%R\" \"%u\"' -f access.log -o json 2>/dev/null")

    assert_equal "Chrome", Utils::JSON.load(output)["browsers"]["data"][0]["data"]
  end
end
