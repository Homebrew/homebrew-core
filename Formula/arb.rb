class Arb < Formula
  desc "C library for arbitrary-precision interval arithmetic"
  homepage "https://arblib.org"
  url "https://github.com/fredrik-johansson/arb/archive/2.20.0.tar.gz"
  sha256 "d2f186b10590c622c11d1ca190c01c3da08bac9bc04e84cb591534b917faffe7"
  license "LGPL-2.1-or-later"
  head "https://github.com/fredrik-johansson/arb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "3791204d0c0dbb5bd44f063344bc8a1615c63a3935f95e74eddbe8ce26a89049"
    sha256 cellar: :any,                 big_sur:       "c3a064874bbd9b6d0d396655977aab35438ce2e3b27be7d2717b3a5e1cbfffac"
    sha256 cellar: :any,                 catalina:      "f6ece3d87456e22119609e0d27489a6b7d47abfc81e0d9967561cb17fe8bdbe3"
    sha256 cellar: :any,                 mojave:        "b6ff4c2466371e7acfbc8da18ff79fbc55c6845ce2aefbcf55775a08b2062885"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1081d079eb89ac2dd78a0c10dfce746cfaf85034979f5c1838b4bc7e572cd2e3"
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
