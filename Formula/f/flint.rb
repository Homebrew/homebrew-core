class Flint < Formula
  desc "C library for number theory"
  homepage "https://flintlib.org/"
  url "https://github.com/flintlib/flint/releases/download/v3.4.0/flint-3.4.0.tar.gz"
  sha256 "9497679804dead926e3affeb8d4c58739d1c7684d60c2c12827550d28e454a33"
  license "LGPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:[._-]?p\d+)?)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7ed744e782c8f2ec39097e89f333493247ed0edb5d4e19c0cb729003a9131791"
    sha256 cellar: :any,                 arm64_sequoia: "394c68bb4acb7026e5bf02843706a61ae1b23dd4c451e18fc23d23c1d2d3867e"
    sha256 cellar: :any,                 arm64_sonoma:  "2180a9d4657aba18c8bba14f55b4594742e5dbd34b505127afa92324b62dad8d"
    sha256 cellar: :any,                 sonoma:        "28805b3eee716445aa9513690841e961f74273c6e5ea33cd2ba23ff3e4002c8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5fa53f2cab0d3a03af52033f31095b06f10cca788ba19119b6788477ae7a9ac5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fb876906fcaadbec62baf8734f08cf0dcda573f7573ce5a303811c889ac1138"
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
