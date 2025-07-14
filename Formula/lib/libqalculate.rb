class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v5.6.0/libqalculate-5.6.0.tar.gz"
  sha256 "2d44130954f327e595af74d0d035f450b560e7997eceb9af16503456d5196f39"
  license "GPL-2.0-or-later"

  bottle do
    sha256                               arm64_sonoma:  "ac6a7805ab37f3751a541acd1995d0143f7cd9fa87c8bd0147f2e2025bbbcd99"
    sha256                               arm64_ventura: "9655075ac02137aeef84feef82c5256b432318912b01a5154d57a0e449140539"
    sha256                               sonoma:        "392ec5a09c12dd230e2a64191bab869a2f7df6b9e82b5cd0d05cb6293b001e06"
    sha256                               ventura:       "c3e16e4f3169171c01192e2db9fd344ebd2890e7d41f9e52dbc35a11ac95bc49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "844808b22f591208c64257833e6eeb4c506afcb7be882bdf00c0632c677b54d6"
  end

  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "pkgconf" => :build
  depends_on "gmp"
  depends_on "gnuplot"
  depends_on "mpfr"
  depends_on "readline"

  uses_from_macos "perl" => :build
  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "perl-xml-parser" => :build
  end

  def install
    ENV.cxx11
    system "./configure", "--disable-silent-rules",
                          "--without-icu",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"qalc", "-nocurrencies", "(2+2)/4 hours to minutes"
  end
end
