class Goaccess < Formula
  desc "Log analyzer and interactive viewer for the Apache Webserver"
  homepage "https://goaccess.io/"
  url "https://tar.goaccess.io/goaccess-1.4.4.tar.gz"
  sha256 "afbd49f4e253e46919af543c0b5d5a818269e4c48d94f3842ce6a01fe3531716"
  license "MIT"
  head "https://github.com/allinurl/goaccess.git"

  bottle do
    sha256 "3c0dabdf4cf0dcd0ee858acb632e396e991d44a029a4f23d8886fd9175c66dba" => :big_sur
    sha256 "1c0c243c3e642ed8b5dd559e9240dbd1585b187682c6ac26e24502af904d5864" => :arm64_big_sur
    sha256 "e7beb072058e44300368fee2c66b6e6c6aa92d770b8f8faa34702350f8e3994e" => :catalina
    sha256 "7bbc3c222cfcb3df427bf80d18a77be050a0fb41dd9e86a2caf3977a2f22c854" => :mojave
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
