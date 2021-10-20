class Arb < Formula
  desc "C library for arbitrary-precision interval arithmetic"
  homepage "https://arblib.org"
  url "https://github.com/fredrik-johansson/arb/archive/2.21.0.tar.gz"
  sha256 "6493ebcfb1772458db4ca66da4c5536968484a3815cf75d2bb33c600b4471910"
  license "LGPL-2.1-or-later"
  head "https://github.com/fredrik-johansson/arb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "129c293ccf5fe95ea73b8108d253b5e786c627817a435d4d5cf1c300e1727110"
    sha256 cellar: :any,                 big_sur:       "7f66b6ea8c88e6b97134158c5f4e27627acfc397c8a25ca9775c4cd6253a1ec2"
    sha256 cellar: :any,                 catalina:      "14516678a24171a98ca03ede69ee3d1cca3e25edca749ffb0a4c427d67cf9870"
    sha256 cellar: :any,                 mojave:        "8bd4187fb3e0747a0ff29b2e102fb511753e8dfb25990ce7edda4f900be8e947"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "592a516186f1fe3af497a648284af29879bfd54f1e6b23865d70ded29241c1bd"
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
