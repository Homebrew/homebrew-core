class Flint < Formula
  desc "C library for number theory"
  homepage "https://flintlib.org/"
  url "https://github.com/flintlib/flint/releases/download/v3.1.3-p1/flint-3.1.3-p1.tar.gz"
  sha256 "96637ba9de43397d06657deefe8e6dee9d226992b5526bb1c9a9d563b983e027"
  license "LGPL-3.0-or-later"
  head "https://github.com/flintlib/flint.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:[._-]?p\d+)?)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "a113c53749915d1b0e588a44db20e403f06d0fd62e6fb8f26bbc68de3c35d8fd"
    sha256 cellar: :any,                 arm64_sonoma:   "74da020f9e6587c8899bda2034e1d94cf4d8b28dde5344c186dcbc45d4d10dab"
    sha256 cellar: :any,                 arm64_ventura:  "ee89cff4b2e4a55c4c1b23b4435a5cb6d3e38bfb7cceaad86cb2d306d92ee86d"
    sha256 cellar: :any,                 arm64_monterey: "f5efdb8826a3bd80de599455dc0aca0dd478276d4edbcde06e80f985cf9688ff"
    sha256 cellar: :any,                 sonoma:         "8c60de59b79be3ab9aa996c3b1b65566751956e24bd47122bb14c7f575f87458"
    sha256 cellar: :any,                 ventura:        "ac40ea9c126354efbd805a2a1d817e38e26c23410abfd9e189790e9c0fc60f11"
    sha256 cellar: :any,                 monterey:       "daf2a177ea8b8b83cc10bf7d9f8719b60c128b335b74fb48b54ca73dca109f1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "999413efcfa5455b771d5fe28356fb36515c41b243bda6f4206240e2dbb3295d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gmp"
  depends_on "mpfr"
  uses_from_macos "m4" => :build

  def install
    # to build against NTL
    ENV.cxx11

    system "./bootstrap.sh" if build.head?

    args = %W[
      --with-gmp=#{Formula["gmp"].prefix}
      --with-mpfr=#{Formula["mpfr"].prefix}
    ]

    if Hardware::CPU.intel?
      # enable/disable avx{2,512}
      # Because flint doesn't use CPUID at runtime
      # we cannot rely on -march options
      if build.bottle?
        # prevent avx{2,512} in case we are building on a machine that supports it
        args << "--enable-arch=#{Hardware.oldest_cpu}"
      elsif Hardware::CPU.avx2?
        # TODO: enable avx512 support
        args << "--enable-avx2"
      end
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
