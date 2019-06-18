class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v3.2.0/libqalculate-3.2.0.tar.gz"
  sha256 "15a7456eb084ecacf3959b78cd764371e4f68a4a9cc3655ec4f335ca14cdefd9"
  revision 1

  bottle do
    sha256 "4c09a54d39580dae9484c333a9bcc549f3b0bec9f41a9b75f7eb7a39d752fd4d" => :mojave
    sha256 "3360350340e90f6d2e658fe4d1058a73b1438675435773336e9a9cb067055cd1" => :high_sierra
    sha256 "1cdbbc17f728923b1f60e19c7fd5e3385a377c3321bce192cc31279fa54381cd" => :sierra
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
