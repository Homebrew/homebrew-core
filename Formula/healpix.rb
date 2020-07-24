class Healpix < Formula
  desc "Hierarchical Equal Area isoLatitude Pixelization of a sphere"
  homepage "https://healpix.jpl.nasa.gov"
  url "https://downloads.sourceforge.net/project/healpix/Healpix_3.70/Healpix_3.70_2020Jul23.tar.gz"
  version "3.70"
  sha256 "8841f171f1e22e75ea130e12e5cdc5bcf85dbec79f9f67dd1bf27e99fd20b6d1"
  license "GPL-2.0-or-later"
  revision 0

  bottle do
    cellar :any
    sha256 "1d9b19c5fc8240ab950fcdc24fc04fcca6111fc649436a4eb46379c7fde2ab33" => :catalina
    sha256 "9d12958cb9bc7cb46739f511a7d99aaf61dc4dda29f3db3db349c40ce005e7ec" => :mojave
    sha256 "3dc30c638e5b12de86ffc99860cb444d10f42cca7786ead6ded1d4b061a45a69" => :high_sierra
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
