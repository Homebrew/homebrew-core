class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v2.6.0a/libqalculate-2.6.0b.tar.gz"
  sha256 "d85c18398fd273e85c9f259e7aa9050aa51f190036815bafb832de779f8a03a7"

  bottle do
    sha256 "0edf1ede4a298b0160118b011160e777e011d1e15f45262e30d9ece3ba8cd301" => :high_sierra
    sha256 "45e1cc6c856cc9b73ba14ce0895ed482886abfdebb17bdf49bbf55ef874f9577" => :sierra
    sha256 "efe399d2d208be3d188fa8b598314afe7c7910a9096aa6ce300b87eddada55e6" => :el_capitan
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gnuplot"
  depends_on "gettext"
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
