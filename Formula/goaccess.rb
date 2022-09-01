class Goaccess < Formula
  desc "Log analyzer and interactive viewer for the Apache Webserver"
  homepage "https://goaccess.io/"
  url "https://tar.goaccess.io/goaccess-1.6.3.tar.gz"
  sha256 "d95646c42af02ece2e246a1aa21452445fd18abe45d4a7dcbbc8394a8c4aeaa8"
  license "MIT"
  head "https://github.com/allinurl/goaccess.git", branch: "master"

  livecheck do
    url "https://goaccess.io/download"
    regex(/href=.*?goaccess[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "161d41eb2faecb7435596b5ae3902fe50a364e68227d88b3503a6d1634423ba4"
    sha256 arm64_big_sur:  "6beccef362f146307de8e4926aa679998f5518f7ce0e14d7615c0b548daefe24"
    sha256 monterey:       "dce157436c98bd1d0bbdf66e7d781ac2cfdcd25297d95cb8e2790c9e929c7f88"
    sha256 big_sur:        "24ab619ceb00ed4fbbb9ba1a5134539998c1a606c5c44114cfd302cd968b751a"
    sha256 catalina:       "17fda0e3dad905281814899ad6e65f25cd531910fa59e3ef02b3867914b41f83"
    sha256 x86_64_linux:   "7c4a2636236f0ede725ab98eefb6b11a5acd49a6c82cc6d8c4425d1600f58607"
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
