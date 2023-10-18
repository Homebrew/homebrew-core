class Goaccess < Formula
  desc "Log analyzer and interactive viewer for the Apache Webserver"
  homepage "https://goaccess.io/"
  url "https://tar.goaccess.io/goaccess-1.8.tar.gz"
  sha256 "19c3ac8d131970abac16831495e9fa32bdb4846ff635e30455e04fbd0dc9653f"
  license "MIT"
  head "https://github.com/allinurl/goaccess.git", branch: "master"

  livecheck do
    url "https://goaccess.io/download"
    regex(/href=.*?goaccess[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "cd1fbdef4f20d39d4ebdc31b06f3d18133e7d78931d1565da9604178c531ea55"
    sha256 arm64_ventura:  "0c1cca6a2e9208c594afd4e87a244932a426e3ebf605dde7141a35e55062e729"
    sha256 arm64_monterey: "2dac0fd1b67905407084ef18225c3ec7a98fb141a87b8526b4d89714baa8145b"
    sha256 sonoma:         "0fc804674b3752bb870d0b58a9b371feea947e51546769f44833966ff6802824"
    sha256 ventura:        "640e2f27936ccbe2a35948543dab2a3a8f36c1624d84cb404fe5a02880930bca"
    sha256 monterey:       "a34d28d86c913dafb07894d88b48d2374a9727f5988ebf1eb59ca849d0ed2aae"
    sha256 x86_64_linux:   "c5a848c319171eff31f794f79e6e804faa9a7e6997ac5fd8a363e8d6f874d65c"
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
