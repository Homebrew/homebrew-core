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
    sha256 arm64_ventura:  "a9ce654bf696db7117baa1e82033eb9489717ebfd5c0a3f3e8bb04354146de74"
    sha256 arm64_monterey: "8128251d66c62aab696f581a232e432adffd379151a9b925759d9718a25d73b3"
    sha256 arm64_big_sur:  "974d619a2f9f273ede88db1b622a89bede32ed526f21c220ba9dc866aae27aff"
    sha256 ventura:        "a8d8a28d525354a619c928d43a5f8a6d880f3b65a11e0ffb414f53491473a48c"
    sha256 monterey:       "23a145e6a858f20a49da751b6eeeced021f270a99dcbde689ac251c25d6c384f"
    sha256 big_sur:        "7ffddc81892ac0b6cb3cf26f317c5dfb12acc2a35d8d0e7fa586422109a36207"
    sha256 x86_64_linux:   "7bfb507161695189549df45337584a5491fd0ea04e37cba42d7633d64d0dc4b0"
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
