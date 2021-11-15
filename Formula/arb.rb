class Arb < Formula
  desc "C library for arbitrary-precision interval arithmetic"
  homepage "https://arblib.org"
  url "https://github.com/fredrik-johansson/arb/archive/2.21.1.tar.gz"
  sha256 "aecc9f55eb35a00a2490e9a7536a0babf8ac86bb13d32a4a95e1216f9f5cbfa8"
  license "LGPL-2.1-or-later"
  head "https://github.com/fredrik-johansson/arb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "41583ad89df5a7377eed7820a2362b1c541d71b946a8984c3de80deef25b8c87"
    sha256 cellar: :any,                 arm64_big_sur:  "90a180e2d81802642eebee8b799be87fee105fe21ee96a387d0d0fa0e6e6bb6f"
    sha256 cellar: :any,                 monterey:       "dca91f023aa5bb528ab8f43a5973180d014385818dc2fdc8108be7de60f3d02c"
    sha256 cellar: :any,                 big_sur:        "43d1508bf8b2902ad5dc670db8827f3183df9ce1069fb15072c2fb578c4c2ebb"
    sha256 cellar: :any,                 catalina:       "4f9d704d41d0b413bfd7523c7217cc7b0b31accf060565dc188424d1ce3bf44d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39945070871bece010b60f8af6d4ed6b79633bd6cf5dbde78a52faebd8cbfea4"
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
