class Flint < Formula
  desc "C library for number theory"
  homepage "https://flintlib.org/"
  url "https://flintlib.org/flint-3.1.0.tar.gz"
  sha256 "b30df05fa81de49c20d460edccf8c410279d1cf8410f2d425f707b48280a2be2"
  license "LGPL-3.0-or-later"
  head "https://github.com/wbhart/flint2.git", branch: "trunk"

  livecheck do
    url "https://flintlib.org/downloads.html"
    regex(/href=.*?flint[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cd9081c8a59306634adce74fe130329c10da59dc5cde3d6d64a97b3db50b3aac"
    sha256 cellar: :any,                 arm64_ventura:  "48298b28a7101f3e1d996b99466dddfe3ab223081704a824822d8b4f262c483c"
    sha256 cellar: :any,                 arm64_monterey: "3402845f37dc68f76013519bb65aa7eb41271350d30af228344665f724af0802"
    sha256 cellar: :any,                 sonoma:         "38b55243359af6245acad6bb3135eb23d3502ac5d4bf53249a0f383f2f1b9911"
    sha256 cellar: :any,                 ventura:        "51e691ed458d7938cc5d43f4231ea7a79afd1b49a01f99b959bc7a729fbd832d"
    sha256 cellar: :any,                 monterey:       "e2cc694938b6af748f2700a3274b5b634bd345c79b824435490ac1e24425cc16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "796f363a97eb42772140b94d31a9eaccfb2acf445175639aba7869250b293942"
  end

  depends_on "gmp"
  depends_on "mpfr"
  depends_on "ntl"

  uses_from_macos "m4" => :build

  def install
    ENV.cxx11
    args = %W[
      --with-gmp=#{Formula["gmp"].prefix}
      --with-mpfr=#{Formula["mpfr"].prefix}
      --with-ntl=#{Formula["ntl"].prefix}
    ]
    if build.bottle?
      args << "ax_cv_check_cxxflags___march_native=no"
      args << "ax_cv_check_cflags___march_native=no"
    end

    system "./configure", *args, *std_configure_args
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
