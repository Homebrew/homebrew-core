class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v2.8.2/libqalculate-2.8.2.tar.gz"
  sha256 "12c41d9a56c89240d8f0e39cac98e66703c620b3a08cb6f39d54193199534a51"
  revision 1

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
