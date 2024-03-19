class Goaccess < Formula
  desc "Log analyzer and interactive viewer for the Apache Webserver"
  homepage "https://goaccess.io/"
  url "https://tar.goaccess.io/goaccess-1.9.1.tar.gz"
  sha256 "eb7718b247962b5c763bce8c0135e915504bf812360133d0b67a1a4e869886f7"
  license "MIT"
  head "https://github.com/allinurl/goaccess.git", branch: "master"

  livecheck do
    url "https://goaccess.io/download"
    regex(/href=.*?goaccess[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "0518148711f733e2e76451867c8a8e54f83d8c7f29aee6325a44fd1440065e98"
    sha256 arm64_ventura:  "c0487740d5cacd61b40ff7eae3513c95f007ea7334f1e9e5ecd2bae0107ac571"
    sha256 arm64_monterey: "a89a96728a954b616e4e33ef90cb317453b2a0a6b73beb30dd61230de18c4654"
    sha256 sonoma:         "c7732be505885c9c3e7bc5646592de5d998627494c8dd0ec95ed6755be4c2c22"
    sha256 ventura:        "e43eba2fdd3dacbdc6e5e6bf22a2612b279c29c907924bd5e24bd83782628203"
    sha256 monterey:       "81ae612279b1e021dd44784856ded4535a6bab395699107b126b302c127b01c9"
    sha256 x86_64_linux:   "bf93b8a48a2fd636c72435552bf2205fd3d3218aca26220616184b9ccbfaf2cd"
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
