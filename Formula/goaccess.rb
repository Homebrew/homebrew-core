class Goaccess < Formula
  desc "Log analyzer and interactive viewer for the Apache Webserver"
  homepage "https://goaccess.io/"
  url "https://tar.goaccess.io/goaccess-1.6.4.tar.gz"
  sha256 "01bcd0bb17332132d0c1c2b452c935a789729bd2518c5a476b79c10293ee2341"
  license "MIT"
  head "https://github.com/allinurl/goaccess.git", branch: "master"

  livecheck do
    url "https://goaccess.io/download"
    regex(/href=.*?goaccess[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "1e02ebf50c70a9f9ef15522adec1605c7704acfa33a022b660614adffbe9c844"
    sha256 arm64_big_sur:  "82ed35c66c874fa216476037d555e9b379325ee4ca3a177972fc6f897b6f7a4b"
    sha256 monterey:       "fcc6dcca4a51da543a121e14f68b6fd49075dc55c4d2195a17b2e9c7bb879c13"
    sha256 big_sur:        "b03a7a6e262904b6b0db781ac6a57a732182cfb9fbc40975f686b533cc66f593"
    sha256 catalina:       "82fd60532bb915ea706cb264800547230b29ea81b9d37902c23e4bb763fb06e2"
    sha256 x86_64_linux:   "af2834fa01fe882412949075c9dea9e999c703e6fa6ba6aaf9be0cf3227582ad"
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
