class Flint < Formula
  desc "C library for number theory"
  homepage "https://flintlib.org/"
  url "https://github.com/flintlib/flint/releases/download/v3.2.2/flint-3.2.2.tar.gz"
  sha256 "577d7729e4c2e79ca1e894ad2ce34bc73516a92f623d42562694817f888a17eb"
  license "LGPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:[._-]?p\d+)?)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4343db1e506cf7681b89d9fcc9230816cd4d7bf2de0d785d6d7391bb74b5ef80"
    sha256 cellar: :any,                 arm64_sonoma:  "18ddb9646c0378d703abe8421ff1de28fc818843274976d1c54e23b938d35945"
    sha256 cellar: :any,                 arm64_ventura: "8f6311ab790eb9d0de362a7fa648cef527f0f70b415cfb03874cddb4f5cc3f45"
    sha256 cellar: :any,                 sonoma:        "f78a8b4f5b0ff5fc9161239acf9d103b07dc2ab59a59cac8f0c25576892f9a42"
    sha256 cellar: :any,                 ventura:       "d25eb9965d322ab870062cc56e89fc13681ade1e36c6f611788bf8d90d32b2fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "daa13f6bf91f9ae87934c0e2b2ceec695793919fe14201f063850b09b9446768"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d247954807d7b273e126f655b68a5c1146f2888ad7e99b7b2df214f3a5ea0534"
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
