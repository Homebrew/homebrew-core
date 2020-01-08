class Gtmess < Formula
  desc "Console MSN messenger client"
  homepage "https://gtmess.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/gtmess/gtmess/0.97/gtmess-0.97.tar.gz"
  sha256 "606379bb06fa70196e5336cbd421a69d7ebb4b27f93aa1dfd23a6420b3c6f5c6"
  revision 2

  bottle do
    sha256 "3c8e2979b478bfe761e2baf263ce4bfdee03426d853ee10faaba353481a21420" => :catalina
    sha256 "9b5e2ecdb133c3a069305f572ec6d172dfaf10371459e44cc84574b08d2db19c" => :mojave
    sha256 "90d1a2aeab88db7022e64335d101d2a10a045a3b8d6c443381ade99b2c13e2d1" => :high_sierra
    sha256 "e8568ea56b4f24521472ae51b4f00bcd704791ec1bcbd6a8a250c7a1e2c43c04" => :sierra
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
