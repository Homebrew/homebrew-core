class Goaccess < Formula
  desc "Log analyzer and interactive viewer for the Apache Webserver"
  homepage "https://goaccess.io/"
  url "https://tar.goaccess.io/goaccess-1.12.tar.gz"
  sha256 "3aef5f6d5061decc6fc4946339b3a61b170bd256f80b4e861194b095df83ec86"
  license "MIT"

  livecheck do
    url "https://goaccess.io/download"
    regex(/href=.*?goaccess[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "28598cdadafc44cc2bf2aa8657faecc7feeb1d761090d2e0c5477ad673b4db13"
    sha256 arm64_tahoe:       "e718f0d4c244e03e9fe8598864e27aa04b12a34b3dd316de308dab48d4700b2d"
    sha256 arm64_sequoia:     "b8e456822cbc356e0d5cedc96a437947dc1efb83ac3c8a5e7b91f87697c3fcc2"
    sha256 arm64_linux:       "b6f1e983bcb2a5504ac9dd4f701d872e3096cfe561a54fea598e91aa81afadc3"
    sha256 x86_64_linux:      "7dce0adedf72e4ad07bc8817dbfe97661ab7ed983631011c5108eef11e8ea309"
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
