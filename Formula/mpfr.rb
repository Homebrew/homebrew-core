class Mpfr < Formula
  desc "C library for multiple-precision floating-point computations"
  homepage "http://www.mpfr.org/"
  url "https://ftp.gnu.org/gnu/mpfr/mpfr-4.0.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/mpfr/mpfr-4.0.1.tar.xz"
  sha256 "67874a60826303ee2fb6affc6dc0ddd3e749e9bfcb4c8655e3953d0458a6e16e"

  bottle do
    cellar :any
    sha256 "e09cdf149a648968e92fb36f88e00746c9e63424f25738bebddb85904c27ba10" => :high_sierra
    sha256 "ff7915ee0cc083fda9c60d1a6c57686d3c64a06cb688965057072cb8b52bce92" => :sierra
    sha256 "01a35f06478a922f99469c2a98bf4de316a4a1271136941078483dc706a12131" => :el_capitan
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
