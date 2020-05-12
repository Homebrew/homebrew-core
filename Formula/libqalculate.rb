class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v3.10.0/libqalculate-3.10.0.tar.gz"
  sha256 "c203ffb1926e2cfd94714b9c3d270d53eddd85d57565d3829bb9ee7407b196db"

  bottle do
    sha256 "23539612692e41e90179cfe64513663cd6b55cb989e8163e7f5353f093c11700" => :catalina
    sha256 "b87485d1e8a6684744d2a527750dc5360f7839b6ba399fbf7fbe8ebf0ed3d077" => :mojave
    sha256 "ba2dd1969dd3cc4aa2d0cfb04dee0ca770135212188cfd8fac6ad7859e681565" => :high_sierra
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnuplot"
  depends_on "mpfr"
  depends_on "readline"

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--without-icu",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/qalc", "-nocurrencies", "(2+2)/4 hours to minutes"
  end
end
