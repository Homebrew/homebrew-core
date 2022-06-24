class Arb < Formula
  desc "C library for arbitrary-precision interval arithmetic"
  homepage "https://arblib.org"
  url "https://github.com/fredrik-johansson/arb/archive/2.22.1.tar.gz"
  sha256 "1ef85518eee04885e8a90196498bc75e4e2410621d4184f2bc01d46b7080a243"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/fredrik-johansson/arb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "24821ce170b1c2429c7ace6af99b37d30c5302d0035f2692bf287d623b0333a0"
    sha256 cellar: :any,                 arm64_big_sur:  "8592a5675e4b51be126cfa3c9611547b5636cc8307fdeceb6094b980be2f3d75"
    sha256 cellar: :any,                 monterey:       "7187b623b29413ff46c89b8175c74fab6e3ab374a2006104bf12b409b1d7888a"
    sha256 cellar: :any,                 big_sur:        "ec5f27ae0166f744754a5fe05dfb8f8fe563cbfcba74de5cb4b8e7e67aa23967"
    sha256 cellar: :any,                 catalina:       "50674ecfe729634dd02adba2d45a3063879a9557c1de7fc64ea84014d2244a6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbbb2e2aa4bf7a44732eb8d903b7c976275a341fa542621536bc60e2c4fe5cef"
  end

  depends_on "cmake" => :build
  depends_on "flint"
  depends_on "gmp"
  depends_on "mpfr"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <arb.h>

      int main()
      {
          slong prec;
          arb_t x, y;
          arb_init(x); arb_init(y);

          for (prec = 64; ; prec *= 2)
          {
              arb_const_pi(x, prec);
              arb_set_si(y, -10000);
              arb_exp(y, y, prec);
              arb_add(x, x, y, prec);
              arb_sin(y, x, prec);
              if (arb_rel_accuracy_bits(y) >= 53) {
                  arb_printn(y, 15, 0); printf("\\n");
                  break;
              }
          }

          arb_clear(x); arb_clear(y);
          flint_cleanup();
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-I#{Formula["flint"].opt_include}",
           "-L#{lib}", "-L#{Formula["flint"].opt_lib}",
           "-larb", "-lflint", "-o", "test"
    assert_match %r{\[-?\d+\.\d+e-\d+ \+/- \d+\.\d+e-\d+\]}, shell_output("./test")
  end
end
