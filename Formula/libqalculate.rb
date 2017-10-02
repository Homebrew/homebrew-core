class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v2.1.0/libqalculate-2.1.0.tar.gz"
  sha256 "7668ed9ab32d46d3638297985a03bc995b6aedf8b8335685e1a43393ba236f12"

  bottle do
    sha256 "a3800e21ca0bae49e731cb94d675b0b33c8859776a1c27439a8443bb32d84c53" => :high_sierra
    sha256 "399990694f3e020f4f52e7c84debd9f365383401b57a47dd36ebc73d90f4c306" => :sierra
    sha256 "8d1170eebb1d0c862beb57bf399a9af73ba10d281fc4ca13e53c4f8f3a2269a2" => :el_capitan
    sha256 "6d136a4bd9e77bc8a2467d776ab566ebd9dd1fe32710950695cc3a2fc15c6c86" => :yosemite
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
