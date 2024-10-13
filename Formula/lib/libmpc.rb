class Libmpc < Formula
  desc "C library for the arithmetic of high precision complex numbers"
  homepage "https://www.multiprecision.org/"
  url "https://ftp.gnu.org/gnu/mpc/mpc-1.3.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/mpc/mpc-1.3.1.tar.gz"
  sha256 "ab642492f5cf882b74aa0cb730cd410a81edcdbec895183ce930e706c1c759b8"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "5c8cdc4d460525025f69157ea5187c4119da8bffab33e7923dc374c011c9cdac"
    sha256 cellar: :any,                 arm64_sonoma:   "909895bde6818f0adee6cf16f23836752ae214515da2e9e3beb0f66fbb63c490"
    sha256 cellar: :any,                 arm64_ventura:  "da4ff781bc469c82af17f98f0bdbf20932e222d0520ab784cd1b322b789ad7a5"
    sha256 cellar: :any,                 arm64_monterey: "dd3994160b3625b1f14e34abf632b90bf49e71db1cc85c12e9ab529d4cae2a87"
    sha256 cellar: :any,                 arm64_big_sur:  "43bbe994c7bbb40f7172ef7a750bc6d2687275a76a25f67fc2d53ef00728d912"
    sha256 cellar: :any,                 sequoia:        "1c63e3a084ca2b4e818ccca9ea563f54a12229679c8bfde43d4cb5cbcf0020af"
    sha256 cellar: :any,                 sonoma:         "504c66775a10810afcaff53506651eafdb6e9c74dd86881e3b9f7c438fcd83d6"
    sha256 cellar: :any,                 ventura:        "aa4ddb0e50ace93746e6af2e6185493698b501e9359cf73ce41cfbb70369db09"
    sha256 cellar: :any,                 monterey:       "c32f2c3fe7ab06e308e6fa74874e1d4d92ff6eb3598da6e0f8e6fa7a333350f5"
    sha256 cellar: :any,                 big_sur:        "47b50c3df6a35ea3c876397eac4a7dc157b5f4109247671a16599a9a41b9c035"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6542ae5bcf643ca0c980c7000cde1585922e76be080b3cc3422dac0d4a50904"
  end

  head do
    url "https://gitlab.inria.fr/mpc/mpc.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "gmp"
  depends_on "mpfr"

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", *std_configure_args,
                          "--with-gmp=#{Formula["gmp"].opt_prefix}",
                          "--with-mpfr=#{Formula["mpfr"].opt_prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <mpc.h>
      #include <assert.h>
      #include <math.h>

      int main() {
        mpc_t x;
        mpc_init2 (x, 256);
        mpc_set_d_d (x, 1., INFINITY, MPC_RNDNN);
        mpc_tanh (x, x, MPC_RNDNN);
        assert (mpfr_nan_p (mpc_realref (x)) && mpfr_nan_p (mpc_imagref (x)));
        mpc_clear (x);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-L#{Formula["mpfr"].opt_lib}",
                   "-L#{Formula["gmp"].opt_lib}", "-lmpc", "-lmpfr",
                   "-lgmp", "-o", "test"
    system "./test"
  end
end
