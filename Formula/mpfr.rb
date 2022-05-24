class Mpfr < Formula
  desc "C library for multiple-precision floating-point computations"
  homepage "https://www.mpfr.org/"
  license "LGPL-3.0-or-later"

  stable do
    url "https://ftp.gnu.org/gnu/mpfr/mpfr-4.1.0.tar.xz"
    mirror "https://ftpmirror.gnu.org/mpfr/mpfr-4.1.0.tar.xz"
    sha256 "0c98a3f1732ff6ca4ea690552079da9c597872d30e96ec28414ee23c95558a7f"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "81ced499f237acfc2773711a3f8aa985572eaab2344a70485c06f72405e4a5e7"
    sha256 cellar: :any,                 arm64_big_sur:  "9df11560dd3650ffae35c134cef6e0e91aad0e862f5c8895c568b828cf0598d5"
    sha256 cellar: :any,                 monterey:       "7eb2f42b8f39d4f721620d1d54417e27fdb93c993e3ffd7e6ad43310cd84de1b"
    sha256 cellar: :any,                 big_sur:        "1e8eb0326f62d3461d420d98af6fc088daca481cae89fd77a75b420d2e76d776"
    sha256 cellar: :any,                 catalina:       "5fcf57834f58c18761c6c7b0eb961eb7f9fc54325b5361bf3a17c4dee6ebc08a"
    sha256 cellar: :any,                 mojave:         "93c0d2ca093819f125300002cd34c1d1b4dfb7a1403729205861bec21388ff12"
    sha256 cellar: :any,                 high_sierra:    "77581a1df66fb1ef55ffb19777d08b0b60fbc3d2d7ad491a8aceb3a6a4bf7ffd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c5f1cfd038e8fbd640795e34e5e23c11244be3eca7781979600ec0d50bb9c0b"
  end

  head do
    url "https://gitlab.inria.fr/mpfr/mpfr.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "gmp"

  def install
    system "./autogen.sh" if build.head?

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}",
                          "--disable-silent-rules"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <mpfr.h>
      #include <math.h>
      #include <stdlib.h>

      int main() {
        mpfr_t x, y;
        mpfr_inits2 (256, x, y, NULL);
        mpfr_set_ui (x, 2, MPFR_RNDN);
        mpfr_root (y, x, 2, MPFR_RNDN);
        mpfr_pow_si (x, y, 4, MPFR_RNDN);
        mpfr_add_si (y, x, -4, MPFR_RNDN);
        mpfr_abs (y, y, MPFR_RNDN);
        if (fabs(mpfr_get_d (y, MPFR_RNDN)) > 1.e-30) abort();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-L#{Formula["gmp"].opt_lib}",
                   "-lgmp", "-lmpfr", "-o", "test"
    system "./test"
  end
end
