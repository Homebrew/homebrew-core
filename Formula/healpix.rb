class Healpix < Formula
  desc "Hierarchical Equal Area isoLatitude Pixelization of a sphere"
  homepage "https://healpix.jpl.nasa.gov"
  url "https://downloads.sourceforge.net/project/healpix/Healpix_3.81/healpix_cxx-3.81.0.tar.gz"
  version "3.81"
  sha256 "8c47da8617cd4d5fcd2a5fdc20eff935cd3cf509b09735ecc336ac54f0c7db79"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "90a28baa2cde6ca4e323d752775350bbcbce427c761200a2f2f31743aeef182a"
    sha256 cellar: :any, big_sur:       "70fd0a39e1eb0378c04a372b19d3e87ec7ac640a6a47e7f070c6bc35b3eacade"
    sha256 cellar: :any, catalina:      "513f76002bb4bb76327dbfab205750d31f0ddd7e6b9e46e86d2b9cfe91f0d4ea"
    sha256 cellar: :any, mojave:        "cbb907c16bb946f4fab1ee58bf279256fc2f7d80d9d551f5800a404b0b915677"
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
