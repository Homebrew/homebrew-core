class Flint < Formula
  desc "C library for number theory"
  homepage "https://flintlib.org/"
  url "https://github.com/flintlib/flint/releases/download/v3.3.1/flint-3.3.1.tar.gz"
  sha256 "64d70e513076cfa971e0410b58c1da5d35112913e9a56b44e2c681b459d3eafb"
  license "LGPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:[._-]?p\d+)?)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0c8d15e07812156084dc351ec75c591cb62cb3bc0d3e1346a5615155c2e5568f"
    sha256 cellar: :any,                 arm64_sonoma:  "80ef75040da0d978d53f888ed1011c2d6278d8e821571572f6f8ee145d226eca"
    sha256 cellar: :any,                 arm64_ventura: "a81860f596d94ddb5d9731cc251537c2386bb1b9471088e7afecf05f06f013ac"
    sha256 cellar: :any,                 sonoma:        "a929163ba8b7fc9e6bcb183dfa81afb4647eaeaae801f59ab7a201bda542995e"
    sha256 cellar: :any,                 ventura:       "510bae88de0f0c6c96d562a0989fe3ad73b85676a2b1970a9563b11d59ce214a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c83a16e962df0ed027021820c452b2283fda7df7d009e0c6763ddba8c46ce5e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b54f682a717039279cb49e7fbfc82ff462861de03668146458afd18438b769f6"
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
