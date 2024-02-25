class Flint < Formula
  desc "C library for number theory"
  homepage "https://flintlib.org/"
  url "https://flintlib.org/flint-3.1.0.tar.gz"
  sha256 "b30df05fa81de49c20d460edccf8c410279d1cf8410f2d425f707b48280a2be2"
  license "LGPL-2.1-or-later"
  head "https://github.com/wbhart/flint2.git", branch: "trunk"

  livecheck do
    url "https://flintlib.org/downloads.html"
    regex(/href=.*?flint[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e75f2c0f162efd57be88f49d2d82e185fe1cb32a47bfcd396aa0aa13606bbaa1"
    sha256 cellar: :any,                 arm64_ventura:  "de5db34546d9d7d45a28fad4d7e8b7209ad29910b779feadfeb8412e5ef628d9"
    sha256 cellar: :any,                 arm64_monterey: "f6a985f0559d1fb8b641f5aefcb5d403b4a00f6687d74f6f34ae4a4fd6271b14"
    sha256 cellar: :any,                 sonoma:         "acddb19a44d203bc6b2bba73e359995b8f83ccf015c89984668315f336029afd"
    sha256 cellar: :any,                 ventura:        "f1355bdf3d0960e3318096e16fe4ae68b411d766a1bb689df9905d97e741f207"
    sha256 cellar: :any,                 monterey:       "c03703bd499c38aca8db90594a56db1933654fda770564f96dd2450081c76fb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd8b74d4c9e922d246704eb30c6ba45462036e26933625a69880d2b9a5245f3e"
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
