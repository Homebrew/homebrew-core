class Flint < Formula
  desc "C library for number theory"
  homepage "https://flintlib.org"
  url "https://flintlib.org/flint-2.8.1.tar.gz"
  sha256 "edfdda7a7cb847db4e55e050349259cbc9778589686007fb45602d36ecfb427e"
  license "LGPL-2.1-or-later"
  head "https://github.com/wbhart/flint2.git", branch: "trunk"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "6f2981ec689748e03ff3f2392d9265ebfafbec6b9112d286bc01d2c96bf4bee0"
    sha256 cellar: :any,                 big_sur:       "52bb668d0ca7fdcadb42dc9ac7450a959f4a59be028796f46ce868f7fd6d16e3"
    sha256 cellar: :any,                 catalina:      "90c565d4e6251aed5a7a4f91475f74a59bfc0f2fd2f3a1b83b9442d42fa4cba2"
    sha256 cellar: :any,                 mojave:        "f1159c2c6288bca9383822507074eb253dd66ac52edfbe89efa0b96d1614f1bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8339963b09affa0fa22b884698a72b8e25ea556ccf063d0be32b1652a3dbad2f"
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
