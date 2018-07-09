class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v2.6.1/libqalculate-2.6.1.tar.gz"
  sha256 "ed4c467ef8b87611f8c15794b16aef15628ba8f45aaa428619f2d58ed4248609"

  bottle do
    sha256 "fa9333376f4f5455dcdf16deea2ddfdcd62989df600ee10d4e18af0091f24104" => :high_sierra
    sha256 "5c9201641fefec37fac4fa3b1c1c34e754863f91e25e37863f141c4e4a085392" => :sierra
    sha256 "efc2c7f0ab772e41a12fee16fc899e83080190c92a1f2337ec1fa516e5a076f0" => :el_capitan
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
