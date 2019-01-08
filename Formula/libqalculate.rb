class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v2.8.2/libqalculate-2.8.2.tar.gz"
  sha256 "12c41d9a56c89240d8f0e39cac98e66703c620b3a08cb6f39d54193199534a51"
  revision 1

  bottle do
    sha256 "a22b26a5fb85109fcde69f0fd17b05efbe5166bace6d86343cbd5f9849362196" => :mojave
    sha256 "991af95a9c840663af3aaf8ea3db7ba5fc7f81c61d7474d634edb5eaf42dec80" => :high_sierra
    sha256 "f456ab94e2d0130037f987db5ff209d62ee8daa468333292f72b59796e3832c4" => :sierra
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
