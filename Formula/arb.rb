class Arb < Formula
  desc "C library for arbitrary-precision interval arithmetic"
  homepage "https://arblib.org"
  url "https://github.com/fredrik-johansson/arb/archive/2.22.1.tar.gz"
  sha256 "1ef85518eee04885e8a90196498bc75e4e2410621d4184f2bc01d46b7080a243"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/fredrik-johansson/arb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f447ed1bf4f5320b1c3a1c977c48056bcc7ac1f44ca10aacaaa474d2f2d3b26d"
    sha256 cellar: :any,                 arm64_big_sur:  "c73ae6b1d8591f54ebce9311d77596f4b5eb2f12c3605384c2ded78e597fbe0d"
    sha256 cellar: :any,                 monterey:       "cefab4042825074505ed3912dd0e1d3880ad117ef2479812a5f750dc25f35c34"
    sha256 cellar: :any,                 big_sur:        "401558ac68c79863e2024218a07bbd2d1f6edeab6a05c3924066ff89f3fd14d2"
    sha256 cellar: :any,                 catalina:       "c4c80821ea0e6f2fff4e345b1aa2c1df3f4d6307bfe2cb4fc1093f56eef80274"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "122fcda827d790dae26f79dbf09de5c682ffef09ebe4489bf8135353595c2b56"
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
