class Goaccess < Formula
  desc "Log analyzer and interactive viewer for the Apache Webserver"
  homepage "https://goaccess.io/"
  url "http://tar.goaccess.io/goaccess-1.2.tar.gz"
  sha256 "6ba9f66540ea58fc2c17f175265f9ed76d74a8432eeac1182b74ebf4f2cd3414"
  head "https://github.com/allinurl/goaccess.git"

  bottle do
    sha256 "684f650435abfda6cb22c96f2dfbd704fb896824b0dc4ae9ac544832b3a76a80" => :sierra
    sha256 "1ddaacdca6e12af6937ba7f0d58150453446d3ab460e132c0e4e677ebcacfdef" => :el_capitan
    sha256 "07176fce595be6dab42c3adf7fbdaff1947e6d4d6a7c5b85444411d5c8a9df6d" => :yosemite
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
    (testpath/"access.log").write <<-EOS.undent
      127.0.0.1 - - [04/May/2015:15:48:17 +0200] "GET / HTTP/1.1" 200 612 "-" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36"
    EOS

    output = shell_output("#{bin}/goaccess --time-format=%T --date-format=%d/%b/%Y --log-format='%h %^[%d:%t %^] \"%r\" %s %b \"%R\" \"%u\"' -f access.log -o json 2>/dev/null")

    assert_equal "Chrome", JSON.parse(output)["browsers"]["data"][0]["data"]
  end
end
