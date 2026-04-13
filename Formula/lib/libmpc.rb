class Libmpc < Formula
  desc "C library for the arithmetic of high precision complex numbers"
  homepage "https://www.multiprecision.org/"
  url "https://ftpmirror.gnu.org/gnu/mpc/mpc-1.4.0.tar.xz"
  mirror "https://ftp.gnu.org/gnu/mpc/mpc-1.4.0.tar.xz"
  sha256 "3210b3a546b1cb00c296ca360891d7740ee6ff06deb02a27a35b20cd3c0bb1a5"
  license "LGPL-3.0-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "56560b939d9b0ce395f6327333d9e22881605826bcdb41a8585db8f4615190db"
    sha256 cellar: :any,                 arm64_sequoia: "7299a1b6870c34190a140491db8343bf8de737785a11eae7c54a00e1bb23d4c7"
    sha256 cellar: :any,                 arm64_sonoma:  "2bad14b62e69ce35641d8b427c23ced4cbbd9d5f0a4005a9f43ed5572f861f2f"
    sha256 cellar: :any,                 tahoe:         "611b774558071066e3409ffd7bab8111519282de5ba6c57cb03193d4f8f4ead7"
    sha256 cellar: :any,                 sequoia:       "c53d7bbd8f2ddc5abce2f335fd39cc2e3bfef79747de7fd50ecfa612f1e41e39"
    sha256 cellar: :any,                 sonoma:        "f0529cb8a22170a7e89664fb1d0ab88df3099b4a803ce7eab95025ec84be14a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ec67f60f8632d20747bbcda129a23201eb76cb1697e37af330d6f74a8b6496d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2390624ce942d121c61874512bcb0af7515770441437f01322e6b2c369cf96d4"
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
    (testpath/"test.c").write <<~C
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
    C
    system ENV.cc, "test.c", "-L#{lib}", "-L#{Formula["mpfr"].opt_lib}",
                   "-L#{Formula["gmp"].opt_lib}", "-lmpc", "-lmpfr",
                   "-lgmp", "-o", "test"
    system "./test"
  end
end
