class Goaccess < Formula
  desc "Log analyzer and interactive viewer for the Apache Webserver"
  homepage "https://goaccess.io/"
  url "https://tar.goaccess.io/goaccess-1.10.1.tar.gz"
  sha256 "32293bc6bc5f6d113e8490c8ff78a10bbc629aa23b0fb428534f53cc0c9a756e"
  license "MIT"

  livecheck do
    url "https://goaccess.io/download"
    regex(/href=.*?goaccess[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "34069388b4e05e37b420a84dfe884befa76395c5821141ac2ecf131e3dd21e1b"
    sha256 arm64_sequoia: "58836399ce03c7300ecb8be29f249b831031ea129ea98ee50c5d6ba9c62f8c70"
    sha256 arm64_sonoma:  "6a2b5a7ba4c78182b4c5d4bc48910c0e2d6d02dd6e6228061a48a6c5cbfba9bb"
    sha256 sonoma:        "8832a89900638b2c49c8ec52555115b5bb1e5a4684256b58773dfc97a7faaa31"
    sha256 arm64_linux:   "788eb0bfa6852f5ee97084683b9219c1161b8078928e92f4c899a8ea0ea8d830"
    sha256 x86_64_linux:  "d6bbc76dd779693b909012b4507fc809738bf0df6478023cb5825b8bebfd368f"
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
