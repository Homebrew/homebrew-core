class Libmpc < Formula
  desc "C library for the arithmetic of high precision complex numbers"
  homepage "http://www.multiprecision.org/mpc/"
  url "https://ftp.gnu.org/gnu/mpc/mpc-1.3.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/mpc/mpc-1.3.1.tar.gz"
  sha256 "ab642492f5cf882b74aa0cb730cd410a81edcdbec895183ce930e706c1c759b8"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f7c2965d722a96d7d23030d76867247f46635cd605df0d5188eef38303b56f40"
    sha256 cellar: :any,                 arm64_monterey: "658a1d260b6f77c431451a554ef8fa36ea2b6db19b38adc05c52821598ce2647"
    sha256 cellar: :any,                 arm64_big_sur:  "6a93bd78c1b55f8b29e11fd1e9c68c6c305ffe74aa5b978ba93189b6d84d1451"
    sha256 cellar: :any,                 ventura:        "2d8b7dd516c0ade793efc25e2e12584e52e4aa265dad49618e98a180a6da5d94"
    sha256 cellar: :any,                 monterey:       "b9984a72544255edf0c2d36dcb75d6adb7e68aa97233b005cf4120b36bb1fe6b"
    sha256 cellar: :any,                 big_sur:        "754667644cc287cd9691fd3215df260aa971562b5a7b6ca65e29b2e15ea1e656"
    sha256 cellar: :any,                 catalina:       "8c037df4b551058d00351676dc2c5ec395bd69c88545fac9ccfd0749dadb8ee2"
    sha256 cellar: :any,                 mojave:         "c229b6def61f4acc41b4b159d93dbc63a5c77f87f61623c9f7c5399da440cc4f"
    sha256 cellar: :any,                 high_sierra:    "939f0ad01d809356e33bdc70a8a8483eb1b021fd5f3723d0e61a2698af00f01b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d74eb5f1377d8fa72fad88baca1bd5f00c29d45ba186fbec89ad690c1d1f721f"
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
