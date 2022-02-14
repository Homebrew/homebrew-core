class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v4.0.0/libqalculate-4.0.0.tar.gz"
  sha256 "1bddd1aa5fc5c0915308400845acf376dcb685bcbd8da90360b3d75b87d4c666"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_monterey: "dc1d55f6e15c83b805115f537749d2f0a5e25a8d9be59b707d8bb6e6981bc367"
    sha256 arm64_big_sur:  "0f90a9aba8beb819f4a200b023cf9193849ad974411c29803f706d1830b39140"
    sha256 big_sur:        "04690ae693a307c9cd858bcf5c2ea139930840a26312734e61dfa2c5d5a8ecaf"
    sha256 catalina:       "6eaced3c40f631eadefb39fa05f1fa7b8fde2266b3fc8b9505e6de2a75b7183b"
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
