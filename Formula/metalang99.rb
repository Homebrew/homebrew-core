class Metalang99 < Formula
  desc "C99 preprocessor-based metaprogramming language"
  homepage "https://github.com/Hirrolot/metalang99"
  url "https://github.com/Hirrolot/metalang99/archive/refs/tags/v1.13.2.tar.gz"
  sha256 "912c6d91b872d34d2b6580d25afc38faccacf6c57462ab1c862010ff4afbf790"
  license "MIT"
  head "https://github.com/Hirrolot/metalang99.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "18db07784d10e03e77e14d5f2d611ce5c899c0b4cc485233736c8d6e93c579fc"
  end

  def install
    prefix.install "include"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <metalang99.h>

      #define factorial(n)          ML99_natMatch(n, v(factorial_))
      #define factorial_Z_IMPL(...) v(1)
      #define factorial_S_IMPL(n)   ML99_mul(ML99_inc(v(n)), factorial(v(n)))

      int main() {
        ML99_ASSERT_EQ(factorial(v(4)), v(24));
        printf("%d", ML99_EVAL(factorial(v(5))));
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-o", "test"
    assert_equal "120", shell_output("./test")
  end
end
