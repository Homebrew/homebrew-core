class Goaccess < Formula
  desc "Log analyzer and interactive viewer for the Apache Webserver"
  homepage "https://goaccess.io/"
  url "https://tar.goaccess.io/goaccess-1.5.2.tar.gz"
  sha256 "a0ce2f9393b2622484e469e95a809dfd52ade4d4200491e43ede1fcb52ab1c8a"
  license "MIT"
  head "https://github.com/allinurl/goaccess.git"

  livecheck do
    url "https://goaccess.io/download"
    regex(/href=.*?goaccess[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "474007482b3a365e2d9174478b2f0eabf287b50c01f53a9acd78476517977853"
    sha256 arm64_big_sur:  "292d5f4238b3246e11110479b95865a8a3fc066145293f64984b5e93ab2c5ce5"
    sha256 monterey:       "f77fc7a11421355439e36587fc0a47ad4332fd345325607ad62a8a21bdc80918"
    sha256 big_sur:        "a80843e2ccd0e1ac3d9ffb75b94eace83d2da6f2c7f60257d6679a0bbfee1997"
    sha256 catalina:       "33c26f86f846232a4cb7b3514944d2b9a5ee5b0d990724f002cb23509daa1c24"
    sha256 mojave:         "7c9c9f1c05874514284fd610117516e67c859e66a0e77cc135c6fd90b5be8ded"
    sha256 x86_64_linux:   "1827c517a5b03ba41e08851e54e0cb70c2fe4a1f385324c0013f131c4cc085d5"
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
