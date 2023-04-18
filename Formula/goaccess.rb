class Goaccess < Formula
  desc "Log analyzer and interactive viewer for the Apache Webserver"
  homepage "https://goaccess.io/"
  url "https://tar.goaccess.io/goaccess-1.7.2.tar.gz"
  sha256 "0e9aaba29c021d1c6a187130a91404730183ee8ab81cd31381854b47149d126b"
  license "MIT"
  head "https://github.com/allinurl/goaccess.git", branch: "master"

  livecheck do
    url "https://goaccess.io/download"
    regex(/href=.*?goaccess[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "b1656c93e860df3b682846424b89323686e705c81da13e4410d3da55b47081b4"
    sha256 arm64_monterey: "fceb54935327c32a8587fec995c5612c9eef90da739a11d7c7bfcb16f20ff800"
    sha256 arm64_big_sur:  "8cf6cfea6018669b432c551db0da39e69e1bb9a51d67681228012c8e2f2e7293"
    sha256 ventura:        "6b3dde77c64d7605605b728b9b7a6ac467aafaef336349e1379556c9d2e6addb"
    sha256 monterey:       "17c49f013cf3a115288e9d96bf572f1a90db329f4d72a3039d12d57ae4c29eb5"
    sha256 big_sur:        "4005e002ced7953941736a720a093cc79a39b3667b07e61a779cd50ed823fb3b"
    sha256 x86_64_linux:   "c7cfe0fd3aa92bb69ea7d645478ea654af460e953e7e2395e24f1d0652b81f4c"
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
    (testpath/"access.log").write(
      '127.0.0.1 - - [04/May/2015:15:48:17 +0200] "GET / HTTP/1.1" 200 612 "-" ' \
      '"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) ' \
      'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36"',
    )

    output = shell_output(
      "#{bin}/goaccess --time-format=%T --date-format=%d/%b/%Y " \
      "--log-format='%h %^[%d:%t %^] \"%r\" %s %b \"%R\" \"%u\"' " \
      "-f access.log -o json 2>/dev/null",
    )

    assert_equal "Chrome", JSON.parse(output)["browsers"]["data"].first["data"]
  end
end
