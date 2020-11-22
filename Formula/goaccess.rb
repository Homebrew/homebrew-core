class Goaccess < Formula
  desc "Log analyzer and interactive viewer for the Apache Webserver"
  homepage "https://goaccess.io/"
  url "https://tar.goaccess.io/goaccess-1.4.2.tar.gz"
  sha256 "f0ea433170058866e57bd5d0f98dc70c3857f4762ca5a29e6ece26d2ccce4f67"
  license "MIT"
  head "https://github.com/allinurl/goaccess.git"

  bottle do
    sha256 "0b4c04afd1f6a57679c018d8df0d15c13104ad9aaa7ae189bb60895f63335e6e" => :big_sur
    sha256 "4c595d0c97f0f73ca0135724e1fb270376803558e061cafb510aacd9b3c03bbf" => :catalina
    sha256 "34b0e6c71bca1e06092f150ae7a71c7fb5a6dd4a1e9fa6a7bac9a4582d768154" => :mojave
    sha256 "f8c7eea092fc381f163565cf8cb925ae84d2d2f26a3f06e8543b9a7672af8932" => :high_sierra
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
