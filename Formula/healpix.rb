class Healpix < Formula
  desc "Hierarchical Equal Area isoLatitude Pixelization of a sphere"
  homepage "https://healpix.jpl.nasa.gov"
  url "https://downloads.sourceforge.net/project/healpix/Healpix_3.60/Healpix_3.60_2019Dec18.tar.gz"
  version "3.60"
  sha256 "bf1797022fb57b5b8381290955e8c4161e3ca9b9d88e3e32d55b092a4a04b500"
  revision 1

  bottle do
    cellar :any
    sha256 "06f325d3c2ca5ea3ba59102406b9db993df33db6eb3767375f30e6dbd736c068" => :catalina
    sha256 "9b32669974a4ad5c1daba24a0841eddb092416c902e6b83d61f34d240e872a7d" => :mojave
    sha256 "9e809e0585035821b9e35cdb2c4bcecba7f6f44528f3470f8b3d73d43312d46b" => :high_sierra
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
