class Goaccess < Formula
  desc "Log analyzer and interactive viewer for the Apache Webserver"
  homepage "https://goaccess.io/"
  url "https://tar.goaccess.io/goaccess-1.7.1.tar.gz"
  sha256 "3d6876d91d02816a93ad86e179369942d914a82bf09d6a6c02964ed7de48610d"
  license "MIT"
  head "https://github.com/allinurl/goaccess.git", branch: "master"

  livecheck do
    url "https://goaccess.io/download"
    regex(/href=.*?goaccess[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "d14f81e03f3b089a8ce0b59c98f3f50ab819e2200d7fc427864bf4b380663f25"
    sha256 arm64_monterey: "98b8012a9b63def036ed7a7a51b584e31310481dca4c4a101e2eadb41d0e25cd"
    sha256 arm64_big_sur:  "ef8fae78f4a509331d385a38ec9f2db55a920ff78a94290a51475ed3556b9a58"
    sha256 ventura:        "b47af49b7f0e0d1e51a8567ad38fa12ba9171d4b2590f2d129ca741af9e857ef"
    sha256 monterey:       "06fbda41d5ca2565ab782d05dac0e27c352fe2f8a7304a85b872042529ecc34c"
    sha256 big_sur:        "a070f300e7e4ee283799a56fc0dfc79254446679fb1b61e9bceebb8c23078af4"
    sha256 x86_64_linux:   "3eda57c20f276bda6e156ad3e3ad1c1a17efa527c5e517151acd5c2d97221db2"
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
