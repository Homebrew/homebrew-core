class Flint < Formula
  desc "C library for number theory"
  homepage "https://flintlib.org/"
  url "https://github.com/flintlib/flint/releases/download/v3.5.0/flint-3.5.0.tar.gz"
  sha256 "3982f385f00610a944e0152eb0a29893b2366fa640e8f5f3076c47564cf7e2a6"
  license "LGPL-3.0-or-later"
  compatibility_version 2

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:[._-]?p\d+)?)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "07228ea96075d3bbc307bdb4f4e89963b37d1f6e0bf4cff2693b3c7272863cbd"
    sha256 cellar: :any,                 arm64_sequoia: "d1b3316320367efa00a3581153c23be9d6ecf2bbd8b8fd0635161a60c81e0f8e"
    sha256 cellar: :any,                 arm64_sonoma:  "c1d3ad5163c2b40110fa684072e9fc1b921fd76f8d0b44e201e8fe3659fd22b6"
    sha256 cellar: :any,                 sonoma:        "3a8516f99c46aaa7a8f493664476760ce0a4d5f1834cdab66392f7d3192a2362"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a588ce46409d24902cc84d7d691a1f3c9c308596a83e6299ebd9eeb3af784dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f185c4bf6b05c018738bbec59d0470e501efa9b92ca7a8e35976365c6da01b5"
  end

  head do
    url "https://github.com/flintlib/flint.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "gmp"
  depends_on "mpfr"

  uses_from_macos "m4" => :build

  def install
    # to build against NTL
    ENV.cxx11

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
        args << if OS.mac?
          "--host=#{ENV.effective_arch}-apple-darwin#{OS.kernel_version}"
        else
          "--host=#{ENV.effective_arch}-unknown-linux-gnu"
        end
      elsif Hardware::CPU.avx2?
        # TODO: enable avx512 support
        args << "--enable-avx2"
      end
    end

    system "./bootstrap.sh" if build.head?
    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdlib.h>
      #include <stdio.h>
      #include "flint.h"
      #include "fmpz.h"
      #include "ulong_extras.h"

      int main(int argc, char* argv[])
      {
          slong i, bit_bound;
          ulong prime, res;
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
    C
    system ENV.cc, "test.c", "-I#{include}/flint", "-L#{lib}", "-L#{Formula["gmp"].lib}",
           "-lflint", "-lgmp", "-o", "test"
    system "./test", "2"
  end
end
