class Goaccess < Formula
  desc "Log analyzer and interactive viewer for the Apache Webserver"
  homepage "https://goaccess.io/"
  url "http://tar.goaccess.io/goaccess-1.0.2.tar.gz"
  sha256 "58a83e201f29f0127b89032fbd40677558a643f6141b8c8413afd1e182f104f1"
  head "https://github.com/allinurl/goaccess.git"

  bottle do
    sha256 "4ccab0916e46ccbbd14eb63704a11ebd812c6c201797bc67a8885fbd2f475bd7" => :sierra
    sha256 "175c517502b2d1373b37a2ec732048b01f6385d50c6b87d66eaad09568b5643f" => :el_capitan
    sha256 "1308e96418654e0423118e77ac9dabde20739bb25714cba5bbcb5e0ea7c28a1a" => :yosemite
    sha256 "c203423728013f2b7d47c3c439c5939bbd5f32937cf3239d07244a3f12942cc7" => :mavericks
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
