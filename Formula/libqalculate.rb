class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v2.2.0/libqalculate-2.2.0.tar.gz"
  sha256 "1f02c58cc14e899a77970d3ad97afe4e3a765e6b602b3f3d38fbc5039d466288"

  bottle do
    sha256 "67031e658dcfddc07109c66bf3b617d4a4c9699ef3d4dd4fd1761309e04f6b18" => :high_sierra
    sha256 "e835e8a05a96cdb54ff6e3b2b028ee880d0450f1e03d713391fdf6b93fa564f4" => :sierra
    sha256 "7caa8d87ee9bef38604fd9b0c11d8fbd9f77356538dc153f2b6be248502f5180" => :el_capitan
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "cln"
  depends_on "glib"
  depends_on "gnuplot"
  depends_on "gettext"
  depends_on "mpfr"
  depends_on "readline"
  depends_on "wget"

  def install
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
