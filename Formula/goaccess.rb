class Goaccess < Formula
  desc "Log analyzer and interactive viewer for the Apache Webserver"
  homepage "https://goaccess.io/"
  url "https://tar.goaccess.io/goaccess-1.5.4.tar.gz"
  sha256 "ab64c6762192e959e0fc9b90a317c17d056bc13418fcd93747dc158ad31d3cf9"
  license "MIT"
  head "https://github.com/allinurl/goaccess.git", branch: "master"

  livecheck do
    url "https://goaccess.io/download"
    regex(/href=.*?goaccess[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "6ce38be4b85c863fe136b582b85da58a5928bd8b7c9ff0451298d4f23ebf3343"
    sha256 arm64_big_sur:  "12bb9a2a457e3255f37b25ee0149ad8060e446a5de1bfa35d5f91cba59229479"
    sha256 monterey:       "4c4b7f63b43541ca3de7186cff1e96e7e19f31be37356056bdfcf9d7a1ff1a6d"
    sha256 big_sur:        "caa76dd6b5b948d683bce58ebec11c6f3c6c7929dd7d2b8038c73aac37cce17a"
    sha256 catalina:       "96af35ae1d7817a65c73d7698e3e6f3469e18d0efb9c980ce05277b1acb957a4"
    sha256 x86_64_linux:   "5ee8ef8978c345b8b56061f3349ff1b7d33f26108fa161548ab4ab848497b3fd"
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
