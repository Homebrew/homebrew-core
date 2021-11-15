class Gtmess < Formula
  desc "Console MSN messenger client"
  homepage "https://gtmess.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/gtmess/gtmess/0.97/gtmess-0.97.tar.gz"
  sha256 "606379bb06fa70196e5336cbd421a69d7ebb4b27f93aa1dfd23a6420b3c6f5c6"
  license "GPL-2.0"
  revision 2

  bottle do
    sha256 arm64_monterey: "7eb7cec9ea1616182e027e04380178c3ae21483d04c51049966e0b745ce76b12"
    sha256 arm64_big_sur:  "107b687b5c567bfec9de27d948f1ead0a9c97e7c2a1abfc3d1a819f756bf508d"
    sha256 monterey:       "eb982bdf6b40c199e5fcf9fd0a6aa76627211617166505cd1c02095333e9c302"
    sha256 big_sur:        "e11c66ecdaba54ce45967b358c5be1cd036a6763e840d842dd5f855578d45e9b"
    sha256 catalina:       "3c8e2979b478bfe761e2baf263ce4bfdee03426d853ee10faaba353481a21420"
    sha256 mojave:         "9b5e2ecdb133c3a069305f572ec6d172dfaf10371459e44cc84574b08d2db19c"
    sha256 high_sierra:    "90d1a2aeab88db7022e64335d101d2a10a045a3b8d6c443381ade99b2c13e2d1"
    sha256 sierra:         "e8568ea56b4f24521472ae51b4f00bcd704791ec1bcbd6a8a250c7a1e2c43c04"
  end

  head do
    url "https://github.com/geotz/gtmess.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl@1.1"

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-ssl=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/gtmess", "--version"
  end
end
