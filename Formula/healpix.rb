class Healpix < Formula
  desc "Hierarchical Equal Area isoLatitude Pixelization of a sphere"
  homepage "https://healpix.jpl.nasa.gov"
  url "https://downloads.sourceforge.net/project/healpix/Healpix_3.70/Healpix_3.70_2020Jul23.tar.gz"
  version "3.70"
  sha256 "8841f171f1e22e75ea130e12e5cdc5bcf85dbec79f9f67dd1bf27e99fd20b6d1"
  license "GPL-2.0-or-later"

  bottle do
    cellar :any
    sha256 "59fd161e08ea1758ed4bbc524d8f9008954ea6bb8e38131b7834ca36e719a9f5" => :catalina
    sha256 "dd732e1a1d931be08b90dd7ba7676d77a929b1f431a1a937ab4d91a32d52c4cf" => :mojave
    sha256 "f18787c3cf20536ee93762580b2537318da0601fd9cde0f28295363b59ee8a0a" => :high_sierra
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
