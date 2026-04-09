class Goaccess < Formula
  desc "Log analyzer and interactive viewer for the Apache Webserver"
  homepage "https://goaccess.io/"
  url "https://tar.goaccess.io/goaccess-1.10.2.tar.gz"
  sha256 "b9b7484a413279863c7d92dc7dd4c19dcb55c0a2d138735efc18570bcc4eaa0e"
  license "MIT"

  livecheck do
    url "https://goaccess.io/download"
    regex(/href=.*?goaccess[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "7a698068fe2b1207233ff61c3b3881a27819d74cdb87e0df2b650703410e089d"
    sha256 arm64_sequoia: "37dc6946eeb5bd7fb4b165bdbb2a6ac3ae0145b866298036c72aa6ac50e66c8e"
    sha256 arm64_sonoma:  "26415e8602250913083cef1155f548207eb22cbda7a1a6712036127218d9a0b3"
    sha256 sonoma:        "4cbf3d537d8c9e062191257c54d5a93859045cd4d9cba190151a6cda454e10d1"
    sha256 arm64_linux:   "e4767498d50629470699c9f3fc3cfc78726f1307bdd61e4005301f394fdab5aa"
    sha256 x86_64_linux:  "790bf490001601ad4681ce502577897ca00bfbfedccc7aec1800562c41c75a53"
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
