class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  # NOTE: Please keep these values in sync with qalculate-gtk.rb when updating.
  url "https://github.com/Qalculate/libqalculate/releases/download/v3.16.1/libqalculate-3.16.1.tar.gz"
  sha256 "bbe837073bf0d1995fe7ead4aae2b2e24260351048f6a513a9ca210342ce8e59"
  license "GPL-2.0-or-later"

  bottle do
    sha256 "16c9d92a54b27995c68411a8d66df631ae26e6871d989c27c7c11e030a2f8d13" => :big_sur
    sha256 "32454bd93b285149db62af76d1829e1872db3beb39346d4e320ac497a4332948" => :arm64_big_sur
    sha256 "d6bb29cc7828ac4d563acddd2ef4c630222203b1fe3c4b5777ecde894e48f404" => :catalina
    sha256 "bafd166c5150377bc39575121e53df3770ebab6da20875dc4044662b7902cfa7" => :mojave
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
