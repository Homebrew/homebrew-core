class Healpix < Formula
  desc "Hierarchical Equal Area isoLatitude Pixelization of a sphere"
  homepage "https://healpix.jpl.nasa.gov"
  url "https://downloads.sourceforge.net/project/healpix/Healpix_3.83/Healpix_3.83_2024Nov13.tar.gz"
  version "3.83"
  sha256 "8876c18efc596fd706b2a004ac15f2fb60b795f2db6fbabea9d8ccf549531dda"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1039b88665f8c877915742a039d606474b18a227399cfe55d19b1214e8f2c9ec"
    sha256 cellar: :any,                 arm64_sonoma:  "26499b8b934a6b4325e443c4082ed15bfdc68d6cbc2cb7f68b218e3fc863c56f"
    sha256 cellar: :any,                 arm64_ventura: "6c0c6ebddf9ff17ee610cbf4329f9d89accc757e0c7fe08e1d145d2bcf366dcf"
    sha256 cellar: :any,                 sonoma:        "f1152df831ae5306a286090a396399c4925971c524e894e2f547307a69189a4a"
    sha256 cellar: :any,                 ventura:       "bf98e96be30ec74832e74d9e81e0ba27178072ac4502d5d24995cc5f8c11b900"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "190d793c48305bbaf8bc6f4e340dbd2ae8f7c26e634d81608738f658bfd9f65b"
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
