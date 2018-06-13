class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v2.6.0a/libqalculate-2.6.0.tar.gz"
  sha256 "0f575baac08669177c0003d1445f7b71eb37f46eccbbb35cc4595373c1f3391d"

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

  # Remove for > 2.6.0
  # Upstream commit 13 Jun 2018 "Fix MacOs build failure with long int
  # coefficient arrays in calendar calculations (issue #96)"
  patch do
    url "https://github.com/Qalculate/libqalculate/commit/d1e6bbe.patch?full_index=1"
    sha256 "4c8e211431d434ce332021a5ac0698b9230c916666461a490071f9aa710a5921"
  end

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
