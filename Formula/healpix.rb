class Healpix < Formula
  desc "Hierarchical Equal Area isoLatitude Pixelization of a sphere"
  homepage "https://healpix.jpl.nasa.gov"
  url "https://downloads.sourceforge.net/project/healpix/Healpix_3.60/Healpix_3.60_2019Dec18.tar.gz"
  version "3.60"
  sha256 "bf1797022fb57b5b8381290955e8c4161e3ca9b9d88e3e32d55b092a4a04b500"

  bottle do
    cellar :any
    sha256 "656592999ec626b28f9ec921a777b63f8aa8d4d3e0cc1d630d4bce93b920a733" => :catalina
    sha256 "e3e275f2804f6ae9ba05b2ba20331505cb5bb4f74efed7a5902b7d98c40164ca" => :mojave
    sha256 "ccbf60ca317bfb17a5c5c4d7d4311567cad05f22183c2347ea52923714b0d1bf" => :high_sierra
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
      system "./configure", "--prefix=#{buildpath}/libsharp", *configure_args
      system "make", "install"
    end

    cd "src/cxx" do
      ENV["SHARP_CFLAGS"] = "-I#{buildpath}/libsharp/include"
      ENV["SHARP_LIBS"] = "-L#{buildpath}/libsharp/lib"
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
