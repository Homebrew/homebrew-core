class Goaccess < Formula
  desc "Log analyzer and interactive viewer for the Apache Webserver"
  homepage "https://goaccess.io/"
  url "https://tar.goaccess.io/goaccess-1.9.4.tar.gz"
  sha256 "107d5a3cb186e6e7a8ac684a88d21a17884f128cb0bc4a4a53696145bb39373d"
  license "MIT"
  head "https://github.com/allinurl/goaccess.git", branch: "master"

  livecheck do
    url "https://goaccess.io/download"
    regex(/href=.*?goaccess[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "e1edb0653e8e2b512774ef933f568313d63e6beb481e5337e0a1661acd4aef45"
    sha256 arm64_sequoia: "1200da514dcbbd2b67d05ed0a8a8484d436ab58d7b7a28fcfabdcfe1fa326023"
    sha256 arm64_sonoma:  "236c28e7d1bdf5b29f780c2397fcee03e8f4673b33a8c30df4ac384d94bd62de"
    sha256 arm64_ventura: "2bbda818439ff95642ad87925871ebba8f6e62b26d31d6ea1d3a791245f720bd"
    sha256 sonoma:        "ab7c21de0f83fb6d09ca2ffedd49b996d8c7e3d80c122e9e1271e8cc5c06bf6e"
    sha256 ventura:       "b730ca1b7fc30ec8c73af8ec2f6f9a60cc409b068f1aacac22d64cb4b7f38e7d"
    sha256 arm64_linux:   "70900505dd30cd579e7d4d4703251142ccc7ab664d54760a88da9e7026cc09d2"
    sha256 x86_64_linux:  "3b8b7b44e55f4f4e5a138ae1bf601478753a15eb0f173baab2271c68723c73c7"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext"
  depends_on "libmaxminddb"
  depends_on "tokyo-cabinet"

  uses_from_macos "ncurses"

  def install
    ENV.append_path "PATH", Formula["gettext"].bin
    system "autoreconf", "--force", "--install", "--verbose"

    args = %W[
      --enable-utf8
      --enable-tcb=btree
      --enable-geoip=mmdb
      --with-libintl-prefix=#{Formula["gettext"].opt_prefix}
    ]

    system "./configure", *args, *std_configure_args
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
