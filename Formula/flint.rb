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
    sha256 cellar: :any,                 arm64_ventura:  "8f7dbbc531e8d64fa8c92c8bf767ab46314143ba084d486520b080a6dda5fcd6"
    sha256 cellar: :any,                 arm64_monterey: "be89510010a3268664926b3b400a6bfb04c68bbc49e1458db1ade0d394cbc585"
    sha256 cellar: :any,                 arm64_big_sur:  "c1ba1710148d555a57c7b0ae9623c5799af577c3cdafb8286f57bd623eb93528"
    sha256 cellar: :any,                 ventura:        "ebb8795940d7d8d89f0ec7746804c4b2ebb4da8ba00fd6dc513aa2a1f5827797"
    sha256 cellar: :any,                 monterey:       "9f90ceb53de5d8d10c75074ab6aa4b8d634bc532b9e3afc91b61c8e0e849518e"
    sha256 cellar: :any,                 big_sur:        "1337e5c2c7937e5a4d86946c2d15741d55fa7a0b54b99ea552cdec1e18807ce2"
    sha256 cellar: :any,                 catalina:       "3149763887d901d8f4c322b8bdac03c1118c285dfd72df588facadf02e24ebb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4449052b84499bc199348182c456d61bd4f1ce6d1ac4020a74d045d0b670bc8b"
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
