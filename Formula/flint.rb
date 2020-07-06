class Flint < Formula
  desc "C library for number theory"
  homepage "http://flintlib.org"
  url "http://flintlib.org/flint-2.6.0.tar.gz"
  sha256 "9089edadd12cbbda4533ab6f58efb7565fd973b5b82a89f53f64203bc3510840"
  license "LGPL-2.1"
  head "https://github.com/wbhart/flint2.git", :branch => "trunk"

  bottle do
    cellar :any
    sha256 "41b01ee2208f8d0218a460621bc0c7abf3191b66593148570b2c8eb471fdf5e3" => :catalina
    sha256 "6a28c66f7966de0a3eb2c8ce590164f3ddacfca7b7152221bd266262f682fe7d" => :mojave
    sha256 "0759d28fbb6175c70d6ccddc9bb9f38a38284eb28ebe2d76ddcca6d4c5ed13ec" => :high_sierra
  end

  depends_on "gmp"
  depends_on "mpfr"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS
      #include <stdlib.h>
      #include <stdio.h>

      #include <flint/flint.h>
      #include <flint/fmpz_mod_poly.h>

      int main(int argc, char* argv[])
      {
          fmpz_t n;
          fmpz_mod_poly_t x, y;

          fmpz_init_set_ui(n, 7);
          fmpz_mod_poly_init(x, n);
          fmpz_mod_poly_init(y, n);
          fmpz_mod_poly_set_coeff_ui(x, 3, 5);
          fmpz_mod_poly_set_coeff_ui(x, 0, 6);
          fmpz_mod_poly_sqr(y, x);
          fmpz_mod_poly_print(x); flint_printf("\\n");
          fmpz_mod_poly_print(y); flint_printf("\\n");
          fmpz_mod_poly_clear(x);
          fmpz_mod_poly_clear(y);
          fmpz_clear(n);

          return EXIT_SUCCESS;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}/flint", "-L#{lib}", "-L#{Formula["gmp"].lib}",
           "-lflint", "-lgmp", "-o", "test"
    system "./test"
  end
end
