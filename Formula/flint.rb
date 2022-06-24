class Flint < Formula
  desc "C library for number theory"
  homepage "https://flintlib.org"
  url "https://flintlib.org/flint-2.9.0.tar.gz"
  sha256 "2fc090d51033c93208e6c10d406397a53c983ae5343b958eb25f72a57a4ce76a"
  license "LGPL-2.1-or-later"
  head "https://github.com/wbhart/flint2.git", branch: "trunk"

  livecheck do
    url "https://flintlib.org/downloads.html"
    regex(/href=.*?flint[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "deda4a59344d38bfcdb8e9758de33bd4e1352cf2baba0d5e461047a7ce297280"
    sha256 cellar: :any,                 arm64_big_sur:  "d202b642acc7f6ae3d2fb43b06182ca91ebdfa97519d5b528590ebf77b1be830"
    sha256 cellar: :any,                 monterey:       "18ea50578610f8b09a7de1b6973d0422fc1397eea486b9b95aae71d8ecc8723d"
    sha256 cellar: :any,                 big_sur:        "78c49e982be4383e2e01974dfc84c2b1ce5625cf0bda27527d9e9a574d787842"
    sha256 cellar: :any,                 catalina:       "d3248d7d86afed1da3dda8de176c2e8dbc556cdcb5d4b9cf54e5099ce08e709f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d35d9c6ceefea408c5593d6063e70f6a85d9ac0971f0ebe0d0dd323b3e5cd1f"
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
