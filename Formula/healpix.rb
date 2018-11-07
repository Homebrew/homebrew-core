class Healpix < Formula
  desc "Hierarchical Equal Area isoLatitude Pixelization of a sphere"
  homepage "https://healpix.jpl.nasa.gov"
  url "https://downloads.sourceforge.net/project/healpix/Healpix_3.40/Healpix_3.40_2018Jun22.tar.gz"
  version "3.40"
  sha256 "f10ce170a10a2f37830c65616554c39005442021741ed19c1efa998994d8a069"

  bottle do
    cellar :any
    sha256 "92101cb2e4318646752c725b75b8c6499eae9f62cea5edf1aa2329128e759d1a" => :mojave
    sha256 "48cdfdf1664a9cd9daa88493b799182e54806c77a68ee697442b2bc142d070e7" => :high_sierra
    sha256 "ba7b07582cac6c714c868a8e5d8c804601ae0837bb8ccaa8739191be5f5e1d41" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "cfitsio"

  def install
    configure_args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]

    cd "src/C/autotools" do
      system "autoreconf", "--install"
      system "./configure", *configure_args
      system "make", "install"
    end

    cd "src/cxx/autotools" do
      system "autoreconf", "--install"
      system "./configure", *configure_args
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
