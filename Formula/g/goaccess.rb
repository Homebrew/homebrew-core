class Goaccess < Formula
  desc "Log analyzer and interactive viewer for the Apache Webserver"
  homepage "https://goaccess.io/"
  url "https://tar.goaccess.io/goaccess-1.11.tar.gz"
  sha256 "01024b129c974582bfe7a4653eb55b1c83cb2b57ab3dda96e820bc185a25ff71"
  license "MIT"

  livecheck do
    url "https://goaccess.io/download"
    regex(/href=.*?goaccess[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "82ba580103ce56e1381c57dd768fa01c9bbc8c4622c9db2df2a31bfe6dcbb961"
    sha256 arm64_sequoia: "526b8d4b348e5a520fb09cf9f725b7669213dde9007c91f9fb0d0eb07d97b504"
    sha256 arm64_sonoma:  "d9f8365df61a0fe016d3fc22056dbfc0146c154e84aa3bbe1afeeaf1c3f5153c"
    sha256 sonoma:        "8a90c9aab787d336896fcda6e34dcd3300a6e3a62cf0c78b977beea884d46cf6"
    sha256 arm64_linux:   "7d95821151d86d700aaac3fa0003f6cd180bb44f10aa0aeee77bfcdc2caf08f6"
    sha256 x86_64_linux:  "4b70eaa508cce11b985f83bb6ee6b092a71127e6e744f71bf4a58ce48b25f956"
  end

  head do
    url "https://github.com/allinurl/goaccess.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
  end

  depends_on "libmaxminddb"

  uses_from_macos "ncurses"

  on_macos do
    depends_on "gettext"
  end

  def install
    args = %w[
      --enable-utf8
      --enable-geoip=mmdb
    ]

    system "autoreconf", "--force", "--install", "--verbose" if build.head?
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
