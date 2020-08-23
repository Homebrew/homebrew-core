class Arb < Formula
  desc "C library for arbitrary-precision interval arithmetic"
  homepage "http://arblib.org"
  url "https://github.com/fredrik-johansson/arb/archive/2.18.1.tar.gz"
  sha256 "9c5c6128c2e7bdc6e7e8d212f2b301068b87b956e1a238fe3b8d69d10175ceec"
  license "LGPL-2.1"
  head "https://github.com/fredrik-johansson/arb.git"

  bottle do
    cellar :any
    sha256 "9315171ee0802ba4fc1e1e8b799f387126c2c2a9adbc8501d659acd3781ad042" => :catalina
    sha256 "2674198ab1752ca366e40c6a0b46b62ea85c6035f28c49239658082d6054b3b1" => :mojave
    sha256 "0560ad466e4bcbe318c00619c86366f13d1265c178bbcdaea034c4064ee0d55e" => :high_sierra
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
