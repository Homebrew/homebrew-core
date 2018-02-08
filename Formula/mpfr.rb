class Mpfr < Formula
  desc "C library for multiple-precision floating-point computations"
  homepage "http://www.mpfr.org/"
  url "https://ftp.gnu.org/gnu/mpfr/mpfr-4.0.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/mpfr/mpfr-4.0.1.tar.xz"
  sha256 "67874a60826303ee2fb6affc6dc0ddd3e749e9bfcb4c8655e3953d0458a6e16e"

  bottle do
    cellar :any
    sha256 "223ac973eb796b275cf751111c458dc1466f82f302e96ca764ea091309d1a963" => :high_sierra
    sha256 "a29b4585cb97715cdab177ea586b3fbee2c578248b115e3b86505724f2b0fc76" => :sierra
    sha256 "33b9a9b53120eae11bf2d241d0285f1bb0410ff133d2ecc1d4df07846da93018" => :el_capitan
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
