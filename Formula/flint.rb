class Flint < Formula
  desc "C library for number theory"
  homepage "https://flintlib.org"
  url "https://flintlib.org/flint-2.8.2.tar.gz"
  sha256 "4e878577dc1e17b27887272ff1dff1721189b078d36682c5ceb71b34cd1b3484"
  license "LGPL-2.1-or-later"
  head "https://github.com/wbhart/flint2.git", branch: "trunk"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "7bed0f8bb3dd09fd9aee3fefb694cb63a33a334a11cbc87cd06d100904574e6f"
    sha256 cellar: :any,                 big_sur:       "dc4f4bf459882be60aa777f45fc48d6eaf7e602aae79fbe76c279ad00ad68d50"
    sha256 cellar: :any,                 catalina:      "d0645143316aeba6f376dbe68095386a2261c06eb619ff4ae35d97ffa1e20483"
    sha256 cellar: :any,                 mojave:        "59fec00e4ca3339439c4ff1b03b42782f203d65926940d05b140f8e81c736fcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc7567b39dfe4b15b5487d10a490edad5f5c334ed4c9770e63c827bd9d665c15"
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
