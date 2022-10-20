class MagicEnum < Formula
  desc "Static reflection for enums (to string, from string, iteration) for modern C++"
  homepage "https://github.com/Neargye/magic_enum"
  url "https://github.com/Neargye/magic_enum/archive/v0.8.1.tar.gz"
  sha256 "6b948d1680f02542d651fc82154a9e136b341ce55c5bf300736b157e23f9df11"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "b6f522d37fbd96ef7ddff60d8ab46a72843dd9757e858c641f6637b34689cbd3"
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
