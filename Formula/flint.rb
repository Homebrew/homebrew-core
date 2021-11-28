class Flint < Formula
  desc "C library for number theory"
  homepage "https://flintlib.org"
  url "https://flintlib.org/flint-2.8.4.tar.gz"
  sha256 "61df92ea8c8e9dc692d46c71d7f50aaa09a33d4ba08d02a1784730a445e5e4be"
  license "LGPL-2.1-or-later"
  head "https://github.com/wbhart/flint2.git", branch: "trunk"

  livecheck do
    url "https://flintlib.org/downloads.html"
    regex(/href=.*?flint[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b5c3e6b7337b40d10f2ace7b9e0bb21284c7915c3b26baa67cba59e234018bff"
    sha256 cellar: :any,                 arm64_big_sur:  "e4206315f3530578a697c9ee0b5fd2b5b57a03a871037ba94ecd095ef4b304d0"
    sha256 cellar: :any,                 monterey:       "9a72a76b27ed77ad1153f1b46e9d0d4408911d297c28a3c32e6b751cff3c2b83"
    sha256 cellar: :any,                 big_sur:        "7820a6249bb4ebea48b62341e0efd7cb90621d8661243116ef7553c593b26db8"
    sha256 cellar: :any,                 catalina:       "0841c62e659a1d82daacd5ead7bfe25efb3b1ba4cc2d50a4b9ee6cedc39e9c87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8cd7e847e4bb90f1783f84e99bf4d34dbe8210c2d2c1360fa9131a4302236f5"
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
