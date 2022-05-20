class Goaccess < Formula
  desc "Log analyzer and interactive viewer for the Apache Webserver"
  homepage "https://goaccess.io/"
  url "https://tar.goaccess.io/goaccess-1.5.7.tar.gz"
  sha256 "d66de6d576eb7f0ac4f97b1b234063251478f27481e29700bd160aef6287cec1"
  license "MIT"
  head "https://github.com/allinurl/goaccess.git", branch: "master"

  livecheck do
    url "https://goaccess.io/download"
    regex(/href=.*?goaccess[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "8ac00ccf044bf01877ce8e1461e21ba10144529c7c322f0fe2555378c129a8a1"
    sha256 arm64_big_sur:  "329c70f0acc84c76447a8a2639a994a221483730dca8f0302841003311f0b4d4"
    sha256 monterey:       "8d659d27dcb96049cd5f3f459b4ffc432ca4063e7d978da4eef145cc925b6c00"
    sha256 big_sur:        "ef9c0bc52331ec3aef80aa58f8a9cd3ce9001825aca514a5ab6e4cc50274ab96"
    sha256 catalina:       "e6734fc40187fa84f5aba824e7d9060c92a77270505a2a53413f20cdb27f767a"
    sha256 x86_64_linux:   "93796acf4a45abe3cb973c661ef364ccb49f32a9466f238d3330d654232a5f35"
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
