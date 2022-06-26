class Goaccess < Formula
  desc "Log analyzer and interactive viewer for the Apache Webserver"
  homepage "https://goaccess.io/"
  url "https://tar.goaccess.io/goaccess-1.6.tar.gz"
  sha256 "1cca38919513a3972b8844e7770938f998892b1d16fb1d91184eee7679e367ab"
  license "MIT"
  head "https://github.com/allinurl/goaccess.git", branch: "master"

  livecheck do
    url "https://goaccess.io/download"
    regex(/href=.*?goaccess[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "e6962d9531ad9499df083015041a0b99be05050915728ce2fb000c3b72839234"
    sha256 arm64_big_sur:  "293863f7c147b923730a4bd56e62d86247d32b32bc57a08fb94d6181c8bb3e38"
    sha256 monterey:       "7f8e644e30a31a7ced7e83fcf05b46fbdf5895ea5e419dc8834bc8f2522e5ab4"
    sha256 big_sur:        "d466da42bbcd780dbd44e1a6ec25f2fe84fff3880a5fcdb461bd21954b292f68"
    sha256 catalina:       "87fefe1ce19d745e35026bbbbf04d449c938d4c533227285980ce496d1defc1a"
    sha256 x86_64_linux:   "08a7a10734aab6576380b502a89875acee0acf6077275d0f32b0527bdd85e267"
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
