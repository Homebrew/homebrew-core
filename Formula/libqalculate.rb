class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v2.6.0a/libqalculate-2.6.0.tar.gz"
  sha256 "0f575baac08669177c0003d1445f7b71eb37f46eccbbb35cc4595373c1f3391d"

  bottle do
    sha256 "0ac3861f551d5d6baa96b28601616ab73b42de95e33ac83c25d70d126375dd50" => :high_sierra
    sha256 "fd6edd7235f0cf2b8afb8e64f3c8d950b2804b6615cb2f6b55d4ecb310ebb273" => :sierra
    sha256 "5c00af069d2f7ec33d0d2a528a28e21952ff226bda7353293e4cf7777a0bccc2" => :el_capitan
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
