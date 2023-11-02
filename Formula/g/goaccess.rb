class Goaccess < Formula
  desc "Log analyzer and interactive viewer for the Apache Webserver"
  homepage "https://goaccess.io/"
  url "https://tar.goaccess.io/goaccess-1.8.1.tar.gz"
  sha256 "7f9432e6e95d0ece40be86d33f3c454b9c5eec31766914bc9c12f9cf4ead4597"
  license "MIT"
  head "https://github.com/allinurl/goaccess.git", branch: "master"

  livecheck do
    url "https://goaccess.io/download"
    regex(/href=.*?goaccess[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "02c343963c5705c09087bc3c67641c45f7289ee6c733654c9f28af80bbe70a54"
    sha256 arm64_ventura:  "a14f75155f45e9da9d5c281de31ee8fee4364d0901752f58ff872ff4608dedc2"
    sha256 arm64_monterey: "84e6c160706b7402664a4771a58ac45073f1d628c20a2c445736615c78dcb30f"
    sha256 sonoma:         "1a7a8d4bfec8f065946716d9947bd7239ae3b80ac33a585adf2b1422d7e26e5a"
    sha256 ventura:        "63a1dfb4f608d12c7cd2517b24803cb431b40d3ac104a72717c8367b39c8a2aa"
    sha256 monterey:       "d8924b2236b8e998b8fbcc2ec4f0712c8b4c1f68bcdb3fbdbae1aa14fd90b397"
    sha256 x86_64_linux:   "c635f3a9a4a75898c34f738e27f14fd54b49ce22521db7011ae6b52e873bb80c"
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
