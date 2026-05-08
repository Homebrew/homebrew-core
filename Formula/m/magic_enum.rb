class MagicEnum < Formula
  desc "Static reflection for enums (to string, from string, iteration) for modern C++"
  homepage "https://github.com/Neargye/magic_enum"
  url "https://github.com/Neargye/magic_enum/archive/refs/tags/v0.9.8.tar.gz"
  sha256 "1e54959a3f3cb675938d858603ad69d0f3f7c82439fc2bf86d7232daec2bd10e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d2ccda5da04b1332011cd1d927cb6a9f4c0f942054ba6a8e7a9101ee43d60d90"
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
