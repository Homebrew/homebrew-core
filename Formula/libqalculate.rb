class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v2.5.0/libqalculate-2.5.0.tar.gz"
  sha256 "283098923b9d6cb300eab54dfa67d2b4bab2cac233e08396e28d29042f7e9c83"

  bottle do
    sha256 "0ac3861f551d5d6baa96b28601616ab73b42de95e33ac83c25d70d126375dd50" => :high_sierra
    sha256 "fd6edd7235f0cf2b8afb8e64f3c8d950b2804b6615cb2f6b55d4ecb310ebb273" => :sierra
    sha256 "5c00af069d2f7ec33d0d2a528a28e21952ff226bda7353293e4cf7777a0bccc2" => :el_capitan
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
