class Flint < Formula
  desc "C library for number theory"
  homepage "http://flintlib.org"
  url "http://flintlib.org/flint-2.6.2.tar.gz"
  sha256 "5f9b45113c3b50c10564a04e9dd929eb8ad96488b5eb901db5723cd21bbae1da"
  license "LGPL-2.1"
  head "https://github.com/wbhart/flint2.git", branch: "trunk"

  bottle do
    cellar :any
    sha256 "ae209ece8e2b1dac05c3df9cc9d486153b5d7e0982c26a811a6038628c46d4d1" => :catalina
    sha256 "827a4a202b966ebea8e4fec9ef76ee221e3f32303af5a07e238c81bd820d1336" => :mojave
    sha256 "ea7193e4401bd3de54e9cb7b3ab4c86d58077e54fe830302b577cdc2ac05e5d4" => :high_sierra
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
