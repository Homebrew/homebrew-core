class Goaccess < Formula
  desc "Log analyzer and interactive viewer for the Apache Webserver"
  homepage "https://goaccess.io/"
  url "https://tar.goaccess.io/goaccess-1.6.5.tar.gz"
  sha256 "355edbf8af2c14879fa4b90c68adcde340eb4efbc443d27de4f8a03a01002df9"
  license "MIT"
  head "https://github.com/allinurl/goaccess.git", branch: "master"

  livecheck do
    url "https://goaccess.io/download"
    regex(/href=.*?goaccess[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "886590e85c0b9716b10b7a60d1ad048d39432dba43bd6958dfb143b56042e905"
    sha256 arm64_monterey: "dcf656034b63fda89d5faec0cd9229e734e6e4725c5ed17ab9c8a1f3a0722673"
    sha256 arm64_big_sur:  "0a5384b80a94ba3508ba698f754d079de3a76b732d210b00747fd15bb61ad44f"
    sha256 ventura:        "36d30a39db4899568d9fcc29486994dd4de76196499f487264dc12ad63f8c260"
    sha256 monterey:       "d2474004196a908305572a9e49c0957179d313be5f784180e00027aedda893f6"
    sha256 big_sur:        "36a1a59d1148afdee7d901034af78c5c4fd99ef1a2d85ca335a6ee020f428b49"
    sha256 catalina:       "78783f01a79bf8660cd0fe32036987ddbf48d64a077f39939523ecb0ca4128b5"
    sha256 x86_64_linux:   "a2ad4054a6ec1a9f1c53f0812a7268468274ede1a63eb41707e2bbddf9c37c00"
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
