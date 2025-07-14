class Metalang99 < Formula
  desc "C99 preprocessor-based metaprogramming language"
  homepage "https://github.com/Hirrolot/metalang99"
  url "https://github.com/Hirrolot/metalang99/archive/refs/tags/v1.13.5.tar.gz"
  sha256 "f3d1607d76b4b081d3295661c4c2b8d5fde4d5018b1aa409c84fb3a6660ffb90"
  license "MIT"
  head "https://github.com/Hirrolot/metalang99.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, all: "72f34a9d242be857c7fbb45ddc50c1c6f0ca5a034d831ee1909d25f2037d600c"
  end

  def install
    prefix.install "include"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <metalang99.h>

      #define factorial(n)          ML99_natMatch(n, v(factorial_))
      #define factorial_Z_IMPL(...) v(1)
      #define factorial_S_IMPL(n)   ML99_mul(ML99_inc(v(n)), factorial(v(n)))

      int main() {
        ML99_ASSERT_EQ(factorial(v(4)), v(24));
        printf("%d", ML99_EVAL(factorial(v(5))));
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-o", "test"
    assert_equal "120", shell_output("./test")
  end
end
