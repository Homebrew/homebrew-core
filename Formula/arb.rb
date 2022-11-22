class Arb < Formula
  desc "C library for arbitrary-precision interval arithmetic"
  homepage "https://arblib.org"
  url "https://github.com/fredrik-johansson/arb/archive/2.23.0.tar.gz"
  sha256 "977d41bde46f5442511d5165c705cec32c03e852c84d7d1836135d412ce702bb"
  license "LGPL-2.1-or-later"
  head "https://github.com/fredrik-johansson/arb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "596adbf061300ff305e92189dcd59a04b8f8a0034e72d09b662ef5a2f9e8a4b3"
    sha256 cellar: :any,                 arm64_monterey: "d0932b89466b24d29e519a6f3875d9f53ae632605e10bc1d473954cb40668016"
    sha256 cellar: :any,                 arm64_big_sur:  "737cd42d550afda9fa9f0017e84fd7a9effcf475db04f8fff887c34fcc35d285"
    sha256 cellar: :any,                 ventura:        "3e7bf8540a66088bf643dfe1672ca89c783864d1e02a898ee48afe5d85f17d5b"
    sha256 cellar: :any,                 monterey:       "2f5244c00ab5acf62eb2d753c6bb1e9582d3b7e4211046192a4f1872118b0a0e"
    sha256 cellar: :any,                 big_sur:        "23b7cdd19bf973d0d9cc8c48489ef2bc79d5bdf0b7d8e1eb19010d01093b1326"
    sha256 cellar: :any,                 catalina:       "f726f1dd8a7c4401def57a1a0d978eb63bb5f9c0e4074afee20f3c9076b4617c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a222fdd6fb56ff3fd9499ea8b6b0626e5935af09a922bff4692988c630d7aeb7"
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
