class Goaccess < Formula
  desc "Log analyzer and interactive viewer for the Apache Webserver"
  homepage "https://goaccess.io/"
  url "https://tar.goaccess.io/goaccess-1.5.6.tar.gz"
  sha256 "df6585f179fdda9240f6a0e772c27b61fa1c88b3320c2409bcdfefbb4b14aabf"
  license "MIT"
  head "https://github.com/allinurl/goaccess.git", branch: "master"

  livecheck do
    url "https://goaccess.io/download"
    regex(/href=.*?goaccess[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "0fc0c2b3a9fbb045d2f8937b849df59b5223ee13511fa2f7503da22909cf79ad"
    sha256 arm64_big_sur:  "72082a43a804651ea6043d6afc59b6d7cd1f4ae38f841fd01379cd8d159b5a69"
    sha256 monterey:       "edb244d59ef39ed433bc9ffd7d84968a99d59bc9ebace5c92880f0627128790c"
    sha256 big_sur:        "7679f67e1689dacb8c89d24e82ff3a4cf5ddae44b00a2607ccbcf2924778d733"
    sha256 catalina:       "2c97e99182eb5403c06c7ad958c3f9256481c668a9e3fe3a25e66a0cc1703490"
    sha256 x86_64_linux:   "fc5321dfcfbd92093b685bffee032fefa1bc87efd3de78e690d80001ad38cd71"
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
