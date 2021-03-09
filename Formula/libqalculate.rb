class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  # NOTE: Please keep these values in sync with qalculate-gtk.rb when updating.
  url "https://github.com/Qalculate/libqalculate/releases/download/v3.17.0/libqalculate-3.17.0.tar.gz"
  sha256 "7ea06b140b9238b44473e07b60e1e8cb5271e45b80cbdc27e7eb2e6f82c2ec8c"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_big_sur: "e9027b4237595ee1e3aacfa3c9691ddaadcc25bfbd59d375f972d343fbb82d45"
    sha256 big_sur:       "14219ac079ba0c4783ec04e3a32fb6673b69311ae5a34e5373db524e9c168713"
    sha256 catalina:      "074a8032235918dfbfd8c4831a9ca3836f8303103163c74ac5d6e59d11228fc5"
    sha256 mojave:        "75ee085e93362f7f3656c099f2f2696f4b7583098e17222e3d20ee8b4aeadd8d"
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
