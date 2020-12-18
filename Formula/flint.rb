class Flint < Formula
  desc "C library for number theory"
  homepage "https://flintlib.org"
  url "https://flintlib.org/flint-2.7.0.tar.gz"
  sha256 "919a722e33b83bb8dad2231fee97caaa40d028ff9c88ee2be645667f3c472f3a"
  license "LGPL-2.1-or-later"
  head "https://github.com/wbhart/flint2.git", branch: "trunk"

  bottle do
    sha256 "7ef5f3fb0cb495fee718960ef8a9386acf7d07bb7f39093fa09f48091be39629" => :big_sur
    sha256 "8f03bf2f3e4054c196b5d7a593b5d3e18b85a0482a9b919ec3939db9a0712ef1" => :catalina
    sha256 "af9627560e4128bf27fd088400890595d886dcc52cb6f752ecfe44738ab893bc" => :mojave
    sha256 "072f386f8b52bf213fb7782c562ee92b179ceb304b83e18a208e762fcbc8dd1f" => :high_sierra
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
      #include "flint.h"
      #include "fmpz.h"
      #include "ulong_extras.h"

      int main(int argc, char* argv[])
      {
          slong i, bit_bound;
          mp_limb_t prime, res;
          fmpz_t x, y, prod;

          if (argc != 2)
          {
              flint_printf("Syntax: crt <integer>\\n");
              return EXIT_FAILURE;
          }

          fmpz_init(x);
          fmpz_init(y);
          fmpz_init(prod);

          fmpz_set_str(x, argv[1], 10);
          bit_bound = fmpz_bits(x) + 2;

          fmpz_zero(y);
          fmpz_one(prod);

          prime = 0;
          for (i = 0; fmpz_bits(prod) < bit_bound; i++)
          {
              prime = n_nextprime(prime, 0);
              res = fmpz_fdiv_ui(x, prime);
              fmpz_CRT_ui(y, y, prod, res, prime, 1);

              flint_printf("residue mod %wu = %wu; reconstruction = ", prime, res);
              fmpz_print(y);
              flint_printf("\\n");

              fmpz_mul_ui(prod, prod, prime);
          }

          fmpz_clear(x);
          fmpz_clear(y);
          fmpz_clear(prod);

          return EXIT_SUCCESS;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}/flint", "-L#{lib}", "-L#{Formula["gmp"].lib}",
           "-lflint", "-lgmp", "-o", "test"
    system "./test 2"
  end
end
