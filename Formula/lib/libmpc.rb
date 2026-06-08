class Libmpc < Formula
  desc "C library for the arithmetic of high precision complex numbers"
  homepage "https://www.multiprecision.org/"
  url "https://ftpmirror.gnu.org/gnu/mpc/mpc-1.4.1.tar.xz"
  mirror "https://ftp.gnu.org/gnu/mpc/mpc-1.4.1.tar.xz"
  sha256 "91204cd32f164bd3b7c992d4a6a8ce6519511aadab30f78b6982d0bf8d73e931"
  license "LGPL-3.0-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5be7168564102d2666af5a9cc06622e4f9abe8f585b63cfe79d5043bff6a7f50"
    sha256 cellar: :any,                 arm64_sequoia: "e7723a06cf55d69322ada010ad25c6b34627674729e41d89f2526edfa7ba6995"
    sha256 cellar: :any,                 arm64_sonoma:  "b44059db5254575ac66388334cf962727ee7deddb0f17e67bba5c2eb919afa53"
    sha256 cellar: :any,                 tahoe:         "fde5950bffd2a85cafce946d99af3e7e6e08908d4933fa246eeed67d833803a7"
    sha256 cellar: :any,                 sequoia:       "6c035aa0556baf634ceda0edc4415b6f03d675568873b6ffec4b8c6146639f44"
    sha256 cellar: :any,                 sonoma:        "cc074bbba9537feeb231f2aa5e3cae8587a4cb95cb807a2d0c1ce49e0cb362cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c594f7be54b7cb22a68484e6128f805b49987cec1131873735bdd2b7e01733a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "734c85661e6c616157f424d9e7199eb83f69a647cb20db6535cc3525b8c6cd9a"
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
