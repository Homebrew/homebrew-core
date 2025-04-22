class MagicEnum < Formula
  desc "Static reflection for enums (to string, from string, iteration) for modern C++"
  homepage "https://github.com/Neargye/magic_enum"
  url "https://github.com/Neargye/magic_enum/archive/refs/tags/v0.9.7.tar.gz"
  sha256 "b403d3dad4ef542fdc3024fa37d3a6cedb4ad33c72e31b6d9bab89dcaf69edf7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4522b89be3d394cfd87829cc5ed355bb25ac0a66c38eb2ad4106b8338719e276"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    system "./build/test/test-cpp17"
    system "./build/test/test-cpp20"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <magic_enum.hpp>

      enum class Color : int { RED = -10, BLUE = 0, GREEN = 10 };

      int main() {
        Color c1 = Color::RED;
        auto c1_name = magic_enum::enum_name(c1);
        std::cout << c1_name << std::endl;
        return 0;
      }
    CPP

    system ENV.cxx, "test.cpp", "-I#{include}/magic_enum", "-std=c++17", "-o", "test"
    assert_equal "RED\n", shell_output(testpath/"test")
  end
end
