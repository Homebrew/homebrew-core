class Goaccess < Formula
  desc "Log analyzer and interactive viewer for the Apache Webserver"
  homepage "https://goaccess.io/"
  url "https://tar.goaccess.io/goaccess-1.6.2.tar.gz"
  sha256 "5a3152ee0ce2bed0dcee6bd3935338f40658c0b3f034b6305745c7440cd76518"
  license "MIT"
  head "https://github.com/allinurl/goaccess.git", branch: "master"

  livecheck do
    url "https://goaccess.io/download"
    regex(/href=.*?goaccess[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "7181211d95e49ad350c702043145a0a189734966bd9e765dc7f446103738c592"
    sha256 arm64_big_sur:  "b12ce8a816077e03134099715091b7266ca9a852650535eda041d67034da5fd6"
    sha256 monterey:       "6a21b85871cd62c4a55ac2d13f9f5f01a381614dc4088ff6251d831b26083d8e"
    sha256 big_sur:        "6952a726fa0e463a330687fafa481b382d6454844e819de21508b56c1b9cdb39"
    sha256 catalina:       "cc75084da50c5972a85e0ef8af6abf344319f256b9a0b98f3f59623a656f6a0f"
    sha256 x86_64_linux:   "f56bffa285c02e8984ea48b56d18873ec4fa6129b7ee02fe334097898ac1cb62"
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
