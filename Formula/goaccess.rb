class Goaccess < Formula
  desc "Log analyzer and interactive viewer for the Apache Webserver"
  homepage "https://goaccess.io/"
  url "https://tar.goaccess.io/goaccess-1.5.5.tar.gz"
  sha256 "f1e4a12db822568aaddfa0c62d53099dbefed05440fc696f46089e1a352669e7"
  license "MIT"
  head "https://github.com/allinurl/goaccess.git", branch: "master"

  livecheck do
    url "https://goaccess.io/download"
    regex(/href=.*?goaccess[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "cf056cafab2f7dce8fe7e29dc216aa9bc10fc8fc2135fdeb575a9293609c30a2"
    sha256 arm64_big_sur:  "d894c17b7eb47e3eb94082a38e0c0b867996f71d82e3f1b975ae89bfe346178e"
    sha256 monterey:       "b6b555b9686d5388add6b48217434c7cad82ee8df60f93b78c115aa42afde184"
    sha256 big_sur:        "1eb226738eb83d6f6c9b7929f4a45a1d2ad21a9f8458ec75624d73df1241108b"
    sha256 catalina:       "39f5dfa84ae1b808a5094c624a19402476e71c8fda4d9cc908755235f2877e61"
    sha256 x86_64_linux:   "9220dba6e8f103fb68706a359facc35d5ea79ffeee46869bd02350c56ccf2b42"
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
