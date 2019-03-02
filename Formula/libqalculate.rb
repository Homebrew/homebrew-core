class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v2.9.0/libqalculate-2.9.0.tar.gz"
  sha256 "a4c62f9b097c78a5fbb9fd5ca7b56c03512a23291511e5c7cd4876155ee43575"

  bottle do
    sha256 "82d95a35ba497a6300cfb02a13c36f6e2c451a5b33f00b626448a987cf486052" => :mojave
    sha256 "3f384668f45c1d511ac9aa0bcfdb6937b7ee7fddbbd4595fe7eea0c21b7881e6" => :high_sierra
    sha256 "a2a2416c92dc426265472058afe42355c5063cc9d880a1cd674b49ac40676e48" => :sierra
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnuplot"
  depends_on "mpfr"
  depends_on "readline"

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
