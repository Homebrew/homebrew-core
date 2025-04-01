class BetterEnums < Formula
  desc "C++ compile-time enum to string, iteration, in a single header file"
  homepage "https://aantron.github.io/better-enums/"
  url "https://github.com/aantron/better-enums/archive/refs/tags/0.11.3.tar.gz"
  sha256 "1b1597f0aa5452b971a94ab13d8de3b59cce17d9c43c8081aa62f42b3376df96"
  license "BSD-2-Clause"
  head "https://github.com/aantron/better-enums.git", branch: "master"

  def install
    include.install "enum.h"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <enum.h>

      BETTER_ENUM(Color, int, Red = 0, Green, Blue)

      int main() {
        Color c = Color::Red;
        std::cout << c._to_string() << std::endl;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test"
    assert_equal "Red", shell_output("./test").strip
  end
end
