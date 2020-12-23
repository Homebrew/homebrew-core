class MagicEnum < Formula
  desc "Static reflection for enums (to string, from string, iteration) for modern C++"
  homepage "https://github.com/Neargye/magic_enum"
  url "https://github.com/Neargye/magic_enum/archive/v0.7.2.tar.gz"
  sha256 "a77895ebc684f7a4dd2e4e06529b22e9ae694037f6dee0753d3ce0bbcd5b3e38"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "9075c66a5f67e4e254de1e53db323d0a6b519c627e55e739b5a9c9bec204087c" => :big_sur
    sha256 "ab11edfbbbbfe410e82b49ff6be4dba2d3298f925c2569d08af1869f675e2d9d" => :catalina
    sha256 "0a95f97cb4ddb9b46f425202c76cfb1b19aa08403ba598d546cdc10b10e0f60c" => :mojave
  end

  depends_on "cmake" => :build

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

    system ENV.cxx, "test.cpp", "-I#{include}", "-Wall", "-Wextra", "-pedantic-errors", "-Werror", "-std=c++17"
    system "./a.out"
  end
end
