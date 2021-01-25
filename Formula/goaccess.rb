class Goaccess < Formula
  desc "Log analyzer and interactive viewer for the Apache Webserver"
  homepage "https://goaccess.io/"
  url "https://tar.goaccess.io/goaccess-1.4.4.tar.gz"
  sha256 "afbd49f4e253e46919af543c0b5d5a818269e4c48d94f3842ce6a01fe3531716"
  license "MIT"
  head "https://github.com/allinurl/goaccess.git"

  bottle do
    sha256 "527c1e4d90f44d3e962630e8069033d0ce85ead276e2ef648e41ec75f08d7b90" => :big_sur
    sha256 "d680eea84ac33cc1265825b9811925f5ae5d565cb4a2be58222b971cb25245e6" => :arm64_big_sur
    sha256 "7d4f0056b16e399c48fbb7c695491dab296b0eccb9b5034cf8473dd1f4d8aa57" => :catalina
    sha256 "aaa132532ebc07d5817cf8f30f3f957f12dcab6b25a3665420bf7aa02ad79c24" => :mojave
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
