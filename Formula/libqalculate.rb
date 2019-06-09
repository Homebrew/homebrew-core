class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v3.2.0/libqalculate-3.2.0.tar.gz"
  sha256 "15a7456eb084ecacf3959b78cd764371e4f68a4a9cc3655ec4f335ca14cdefd9"

  bottle do
    sha256 "4cc393feb1dca61b29ecc8fe78f708d3a232d16fab5331f4c82b325a8d450445" => :mojave
    sha256 "0a1c72b7940417dadbf7117088b43fa1c00db1c767578d55d2ed71c4337d64cf" => :high_sierra
    sha256 "22e3c6cf351879e75a4e6a491e5c66f505694d9737a4c2a35ec743da0da5c76b" => :sierra
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
