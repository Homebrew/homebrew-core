class Arb < Formula
  desc "C library for arbitrary-precision interval arithmetic"
  homepage "https://arblib.org"
  url "https://github.com/fredrik-johansson/arb/archive/2.22.1.tar.gz"
  sha256 "1ef85518eee04885e8a90196498bc75e4e2410621d4184f2bc01d46b7080a243"
  license "LGPL-2.1-or-later"
  head "https://github.com/fredrik-johansson/arb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "84c04a9ef6babf020a9b206952a190a3615ec6f4308511ca6e3666d918daea6c"
    sha256 cellar: :any,                 arm64_big_sur:  "114fc3d09584a41b1a9b575614336cf967256538af25a8d8f606bdc667e76dee"
    sha256 cellar: :any,                 monterey:       "30f935efac95853a4811364722ea7c937061d41262d5e926c6138ac26157265f"
    sha256 cellar: :any,                 big_sur:        "1214b6c2a51060fefc333407e5cfe3cbd1389bbed5a5e858836b9fa62b508346"
    sha256 cellar: :any,                 catalina:       "02d6f6518b610cf5edd8331efb75287e51c89a09a59b8e3d22e1554960d8cd34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d91ac6193c1afb9b98325a4501572c3a493a2a168fd9461105c84e859ee051b4"
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
