class Healpix < Formula
  desc "Hierarchical Equal Area isoLatitude Pixelization of a sphere"
  homepage "https://healpix.sourceforge.io"
  url "https://downloads.sourceforge.net/project/healpix/Healpix_3.83/Healpix_3.83_2024Nov13.tar.gz"
  version "3.83"
  sha256 "8876c18efc596fd706b2a004ac15f2fb60b795f2db6fbabea9d8ccf549531dda"
  license "GPL-2.0-or-later"
  revision 2

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2cd47768112373cf69d551358a450576de47148b04927854453825f6f4d7ea34"
    sha256 cellar: :any,                 arm64_sequoia: "0497504cbe071a0de19f56a2c2091c28d796141f7aecb37e8ab3473cf7d6c401"
    sha256 cellar: :any,                 arm64_sonoma:  "8589afbe8752f4d93b15e68173266298dccc286e15d8b131021dc6913f433790"
    sha256 cellar: :any,                 sonoma:        "95a5b5a8fa81458c51480629f45133744ae06bedd47c89c9b6ec37b846caed2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2192382257e157d5c43c23f0ceb74e2ceb6616e286d21f1918d914a1afa7eef1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e564d3d9c546315968321c06b82468e6f6120b873dfb9422c4316bd13d3e238"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "cfitsio"

  def install
    cd "src/C/autotools" do
      system "autoreconf", "--force", "--install", "--verbose"
      system "./configure", "--disable-silent-rules", *std_configure_args
      system "make", "install"
    end

    cd "src/common_libraries/libsharp" do
      system "./configure", "--disable-silent-rules", *std_configure_args
      system "make", "install"
    end

    cd "src/cxx" do
      ENV["SHARP_CFLAGS"] = "-I#{include}"
      ENV["SHARP_LIBS"] = "-L#{lib} -lsharp"
      system "./configure", "--disable-silent-rules", *std_configure_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cxx").write <<~CPP
      #include <math.h>
      #include <stdio.h>
      #include "chealpix.h"
      int main(void) {
        long nside, npix, pp, ns1;
        nside = 1024;
        for (pp = 0; pp < 14; pp++) {
          nside = pow(2, pp);
          npix = nside2npix(nside);
          ns1  = npix2nside(npix);
        }
      };
    CPP

    system ENV.cxx, "-o", "test", "test.cxx", "-L#{lib}", "-lchealpix"
    system "./test"
  end
end
