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
    sha256 "2247c9011332a8a0b58429fe87e32dafa1ab0d9e6ad949f63005879544ae7914" => :big_sur
    sha256 "0e83a92b14db51893838ac8a35e0463593a986a75d95235ab574651acd437326" => :catalina
    sha256 "585c4e018bb9a6d95fd68f8bc84d24069a14780c2eedc720cfd3e3ba479f68e6" => :mojave
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
