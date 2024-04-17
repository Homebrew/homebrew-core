class Goaccess < Formula
  desc "Log analyzer and interactive viewer for the Apache Webserver"
  homepage "https://goaccess.io/"
  url "https://tar.goaccess.io/goaccess-1.9.2.tar.gz"
  sha256 "4064234320ab8248ee7a3575b36781744ff7c534a9dbc2de8b2d1679f10ae41d"
  license "MIT"
  head "https://github.com/allinurl/goaccess.git", branch: "master"

  livecheck do
    url "https://goaccess.io/download"
    regex(/href=.*?goaccess[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "8fd1dd5b8bfd7ea93ef555c6f9be6b9a8a3bb0d316237d1a9738716038739e75"
    sha256 arm64_ventura:  "794659211781c6666ebb05a9654009cdce003f030a0255d605a221938066fdc0"
    sha256 arm64_monterey: "1251bd54c07021bfe85b7b5343ca48e40daf99f0335fd2dd93464b3e4a22ccac"
    sha256 sonoma:         "e1bf74e33740213b04ac06e9321850735585eddc62ceb7b54dcbfb4c3fb906c8"
    sha256 ventura:        "8c44d82cbe44f17659b0ee88bca3dc5dc1a5ff4bf6484c8ba551a656ec22b9bb"
    sha256 monterey:       "31938ca561a5c6906f2510799554815f5d5c092c3796b42e8aa00268e3e70fcd"
    sha256 x86_64_linux:   "48bf7651f109ff702a19870481425fff7e447ee0543c57a832323b2e925e92b9"
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
    (testpath/"access.log").write(
      '127.0.0.1 - - [04/May/2015:15:48:17 +0200] "GET / HTTP/1.1" 200 612 "-" ' \
      '"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) ' \
      'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36"',
    )

    output = shell_output(
      "#{bin}/goaccess --time-format=%T --date-format=%d/%b/%Y " \
      "--log-format='%h %^[%d:%t %^] \"%r\" %s %b \"%R\" \"%u\"' " \
      "-f access.log -o json 2>/dev/null",
    )

    assert_equal "Chrome", JSON.parse(output)["browsers"]["data"].first["data"]
  end
end
