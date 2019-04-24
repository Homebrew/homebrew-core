class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v3.1.0/libqalculate-3.1.0.tar.gz"
  sha256 "40174309c59a0eebdc42d63b230662d8b897bee21a6a31f10d7387b17b133a11"

  bottle do
    sha256 "a9caeaee8e1697f0d3003bb53ff72a23c1b1d013f31f866477d410ac91f55e87" => :mojave
    sha256 "1ae9745fa0f12b2ae7e372ca7cb732d55bfcbff90510cef086c2784e600b8723" => :high_sierra
    sha256 "561e00ddcc60e1f4f65636bb8827c540d89730ca1e45cd0f2e9399009b71db54" => :sierra
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
