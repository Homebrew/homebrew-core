class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  # NOTE: Please keep these values in sync with qalculate-gtk.rb when updating.
  url "https://github.com/Qalculate/libqalculate/releases/download/v3.21.0/libqalculate-3.21.0.tar.gz"
  sha256 "2a2b6f8de4b43acdff98efdda338436db1a3f7ecd994e1bc2a422a65fba03479"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_big_sur: "ea662f5e824dcf813ca33c1481877464b1d9480d86eef57ca743a4f177090c25"
    sha256 big_sur:       "945c635fb1b89e751aabcaad6c5c51a4b37f2e7cd62a02b55d8d8f9f9c71e269"
    sha256 catalina:      "4e88aca4d2abce790909e6b3714271894c013c825b47c4061bb86df31dc643a1"
    sha256 mojave:        "605adf531f972d86e78990562f1522df19701082c663d8f8cc1e6199003e8591"
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
