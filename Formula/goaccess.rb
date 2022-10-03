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
    sha256 arm64_monterey: "332f33cde730aeae95da43480181178c07e43b2a67dc1277adecf4a8db7e880a"
    sha256 arm64_big_sur:  "153953944816c72591488c7a4370cbc4d65b503627bd63785d5bcee9453afdc8"
    sha256 monterey:       "e8a26915d08a88212a79c577afb3db8adc80ab3262e9007c3b3d2c3a39a66a25"
    sha256 big_sur:        "0a1ae77b5813df6c04b97bd3c0eea71ae99401ec3ddb4d39062caaee67faba6d"
    sha256 catalina:       "f4f43c065d2c5e7c348ce3a37df5ed3ef2ad35c04b779771061908ab181503b5"
    sha256 x86_64_linux:   "bf3b69dc7213f037cb3d5f4993d0c759b9f4acd6d3309ec4044bc759a4f6e59f"
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
