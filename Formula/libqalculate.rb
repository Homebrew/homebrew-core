class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v2.6.0a/libqalculate-2.6.0b.tar.gz"
  sha256 "d85c18398fd273e85c9f259e7aa9050aa51f190036815bafb832de779f8a03a7"

  bottle do
    sha256 "81d1537c04070be25383bf4a0c27d5d560a7d65993c1ab83b3c7574b7141bb91" => :high_sierra
    sha256 "f07cde2548e9a67a40673a0fa85ed85912cae1c300dc22bba3ec03db44c3111f" => :sierra
    sha256 "f675c403cbd363145032fd8a65e978e487b21075d22c122f1c7c7c4dc793ddb0" => :el_capitan
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
