class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v3.14.0/libqalculate-3.14.0.tar.gz"
  sha256 "ef422aa54eac7c711ece65dd3a5cbc66370d3e17173465313201897c201e7d3e"
  license "GPL-2.0-or-later"

  bottle do
    sha256 "ca36f2273528549168559917caca9cad1692a0dd3d176e4760bf64a345e417fa" => :catalina
    sha256 "57211938d2c99e74c812f5d36990580e091b38e990cd00efb0336986cfd1a8cd" => :mojave
    sha256 "84d5592e4e7aac2bf605f882b3f483412a5ac332220322fe2b1a1db28dcbb288" => :high_sierra
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
