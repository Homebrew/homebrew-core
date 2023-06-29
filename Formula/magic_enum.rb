class MagicEnum < Formula
  desc "Static reflection for enums (to string, from string, iteration) for modern C++"
  homepage "https://github.com/Neargye/magic_enum"
  url "https://github.com/Neargye/magic_enum/archive/v0.9.3.tar.gz"
  sha256 "3cadd6a05f1bffc5141e5e731c46b2b73c2dbff025e723c8abaa659e0a24f072"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d106a548298cae974bd65aded36cc2812bfefaa4d5bd111a50cbb3235dc49336"
  end

  depends_on "cmake" => :build

  fails_with gcc: "5" # C++17

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    system "./test/test-cpp17"
    system "./test/test-cpp17"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <magic_enum.hpp>

      enum class Color : int { RED = -10, BLUE = 0, GREEN = 10 };

      int main() {
        Color c1 = Color::RED;
        auto c1_name = magic_enum::enum_name(c1);
        std::cout << c1_name << std::endl;
        return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-I#{include}", "-std=c++17", "-o", "test"
    assert_equal "RED\n", shell_output(testpath/"test")
  end
end
