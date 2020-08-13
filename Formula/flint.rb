class Flint < Formula
  desc "C library for number theory"
  homepage "http://flintlib.org"
  url "http://flintlib.org/flint-2.6.3.tar.gz"
  sha256 "ce1a750a01fa53715cad934856d4b2ed76f1d1520bac0527ace7d5b53e342ee3"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/wbhart/flint2.git", branch: "trunk"

  bottle do
    cellar :any
    sha256 "9b8d1495a83baee84f260abfae043cadc60b5f88fd5234996d386f6a07e8c42f" => :catalina
    sha256 "8335ac9e0c42ac2ebb2272694a5e2a273bf82bb0895a0ba6ffaef7322ca94c73" => :mojave
    sha256 "74b721ccd5dca704b9e884190e15b4068587d5438a4e1e0a70e23bff2de5d77e" => :high_sierra
  end

  depends_on "gmp"
  depends_on "mpfr"
  depends_on "ntl"

  def install
    ENV.cxx11
    args = %W[
      --with-gmp=#{Formula["gmp"].prefix}
      --with-mpfr=#{Formula["mpfr"].prefix}
      --with-ntl=#{Formula["ntl"].prefix}
      --prefix=#{prefix}
    ]
    system "./configure", *args
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
