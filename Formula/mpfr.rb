class Mpfr < Formula
  desc "C library for multiple-precision floating-point computations"
  homepage "https://www.mpfr.org/"
  url "https://ftp.gnu.org/gnu/mpfr/mpfr-4.0.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/mpfr/mpfr-4.0.2.tar.xz"
  sha256 "1d3be708604eae0e42d578ba93b390c2a145f17743a744d8f3f8c2ad5855a38a"

  bottle do
    cellar :any
    sha256 "140d29bfee0c8cf356fbb5391465f781df559e6076988de3ea8bcfd812f3c5bd" => :catalina
    sha256 "cfce7ab866e98360c9364cd924da620ae7936d3a224d686aacc209c2107d19aa" => :mojave
    sha256 "bf5d21e7e8e549f7e8d07791a90f44a487f4c7151897b7c64d02928b5bd73520" => :high_sierra
    sha256 "4fb1860a481e24c70eefc8e5782030612840f1bb8f50586ca76a4c6c53629deb" => :sierra
  end

  depends_on "gmp"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}",
                          "--disable-silent-rules"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <mpfr.h>
      #include <math.h>
      #include <stdlib.h>

      int main() {
        mpfr_t x, y;
        mpfr_inits2 (256, x, y, NULL);
        mpfr_set_ui (x, 2, MPFR_RNDN);
        mpfr_root (y, x, 2, MPFR_RNDN);
        mpfr_pow_si (x, y, 4, MPFR_RNDN);
        mpfr_add_si (y, x, -4, MPFR_RNDN);
        mpfr_abs (y, y, MPFR_RNDN);
        if (fabs(mpfr_get_d (y, MPFR_RNDN)) > 1.e-30) abort();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-L#{Formula["gmp"].opt_lib}",
                   "-lgmp", "-lmpfr", "-o", "test"
    system "./test"
  end
end
