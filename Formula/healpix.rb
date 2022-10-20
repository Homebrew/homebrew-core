class Healpix < Formula
  desc "Hierarchical Equal Area isoLatitude Pixelization of a sphere"
  homepage "https://healpix.jpl.nasa.gov"
  url "https://downloads.sourceforge.net/project/healpix/Healpix_3.82/Healpix_3.82_2022Jul28.tar.gz"
  version "3.82"
  sha256 "47629f057a2daf06fca3305db1c6950edb9e61bbe2d7ed4d98ff05809da2a127"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "cadea8f03edf6b0be477bad212d7d9430acfdd1dda5f323bb2b31ce5ad846455"
    sha256 cellar: :any,                 arm64_big_sur:  "03d1980b6da3acaa9b2dafad82a978b0d30a747ad6856bc9225551ab21c6fac7"
    sha256 cellar: :any,                 monterey:       "5d38090ecd6924a73ba6c384198f14605335eeb752abbedf5783bd06e6fc8a27"
    sha256 cellar: :any,                 big_sur:        "153d21ddb88d85138eb6c2d5e839ca892e40af84fdf8c9871bbf7937c34191b2"
    sha256 cellar: :any,                 catalina:       "bab37de0e96ff73ec0866c512fb91d67603770249f51897a4e2535b5f37ae7b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5abc18ed2b8160be9e93ec394bdd672fa39b9abbbe618ceab1479965d15ee232"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "cfitsio"

  def install
    configure_args = %w[
      --disable-dependency-tracking
      --disable-silent-rules
    ]

    cd "src/C/autotools" do
      system "autoreconf", "--install"
      system "./configure", "--prefix=#{prefix}", *configure_args
      system "make", "install"
    end

    cd "src/common_libraries/libsharp" do
      system "./configure", "--prefix=#{prefix}", *configure_args
      system "make", "install"
    end

    cd "src/cxx" do
      ENV["SHARP_CFLAGS"] = "-I#{include}"
      ENV["SHARP_LIBS"] = "-L#{lib} -lsharp"
      system "./configure", "--prefix=#{prefix}", *configure_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cxx").write <<-EOS
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
    EOS

    system ENV.cxx, "-o", "test", "test.cxx", "-L#{lib}", "-lchealpix"
    system "./test"
  end
end
