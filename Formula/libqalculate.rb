class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v2.2.0/libqalculate-2.2.0.tar.gz"
  sha256 "1f02c58cc14e899a77970d3ad97afe4e3a765e6b602b3f3d38fbc5039d466288"

  bottle do
    sha256 "5ace7754ec90eef2c421c83355b59245cafe077450160e1d1ceea37076a34a56" => :high_sierra
    sha256 "a1532b5372600419e5c5fc3d6321ad65b2a7500eb2be1ce3808e312dd13e7cbf" => :sierra
    sha256 "b3ad1c22b1791ca03d8a698a850bbd3a3bc47ba87113a898f4c7f1a73e33bb21" => :el_capitan
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
