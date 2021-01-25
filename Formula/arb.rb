class Arb < Formula
  desc "C library for arbitrary-precision interval arithmetic"
  homepage "https://arblib.org"
  url "https://github.com/fredrik-johansson/arb/archive/2.19.0.tar.gz"
  sha256 "0aec6b492b6e9a543bdb3287a91f976951e2ba74fd4de942e692e21f7edbcf13"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/fredrik-johansson/arb.git"

  bottle do
    cellar :any
    sha256 "0e09a51868eb29ac963d7a05de8d69582b84fcaa0daeda65d36a4836b3e8ce7a" => :big_sur
    sha256 "d18804a179a6ea97014edb435487532e308fd3418250b0de06306e810c10e863" => :arm64_big_sur
    sha256 "735bd3b8dc3f89429d51b1fed7b0a651176d2816402eb5c88b7e7a33709d723f" => :catalina
    sha256 "e2001e15a3cab1166c517a366269ad88258748cd8373253f071450d433c7f8cb" => :mojave
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
