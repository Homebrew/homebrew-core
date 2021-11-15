class Flint < Formula
  desc "C library for number theory"
  homepage "https://flintlib.org"
  url "https://flintlib.org/flint-2.8.3.tar.gz"
  sha256 "2c3c2dbfb82242c835be44341d893ca69384d4d0b9448a3aac874e16c623cd59"
  license "LGPL-2.1-or-later"
  head "https://github.com/wbhart/flint2.git", branch: "trunk"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5c261f01334d3dc384b7ffb8de52cdfc7ef1d9f446e1b81bd2aede949e9b8bfb"
    sha256 cellar: :any,                 arm64_big_sur:  "eaa38dc9550e87ddd1f062468c95388bc1d4f4de46e4027eb310061a80ed47d3"
    sha256 cellar: :any,                 monterey:       "e0d3af2b04319a268ef03f87c401a402ef96a57e4248866febd36d53c68bf9a4"
    sha256 cellar: :any,                 big_sur:        "abf32efc7bda674627a6823e920e46019e558df04b73aaffc0c538f68001c61c"
    sha256 cellar: :any,                 catalina:       "df6457ac6703478f2794d0aa5124bac0f6908a85c9ec72765fba2d4d810fc9c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bb248b09effce3393ae7a86be133ac69b4c62f2f15606fba05607bb47d12aa4"
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
    system "./test", "2"
  end
end
