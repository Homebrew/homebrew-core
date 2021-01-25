class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  # NOTE: Please keep these values in sync with qalculate-gtk.rb when updating.
  url "https://github.com/Qalculate/libqalculate/releases/download/v3.16.1/libqalculate-3.16.1.tar.gz"
  sha256 "bbe837073bf0d1995fe7ead4aae2b2e24260351048f6a513a9ca210342ce8e59"
  license "GPL-2.0-or-later"

  bottle do
    sha256 "203f33a641f7943496759835c6fcb820c310967633329bfed900383caaac719a" => :big_sur
    sha256 "87c5462cdae038d172ce29042676d59cd283f07f13211488bde48b90e2eae8eb" => :arm64_big_sur
    sha256 "446758665a4de9b0e60be08cec6e30ea6da6310633d4bf678c9982425e81a4f6" => :catalina
    sha256 "c75a186bf5077108bea3a3165757742f220547a5311544af7d700b7f802a851e" => :mojave
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
