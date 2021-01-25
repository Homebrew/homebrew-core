class MagicEnum < Formula
  desc "Static reflection for enums (to string, from string, iteration) for modern C++"
  homepage "https://github.com/Neargye/magic_enum"
  url "https://github.com/Neargye/magic_enum/archive/v0.7.2.tar.gz"
  sha256 "a77895ebc684f7a4dd2e4e06529b22e9ae694037f6dee0753d3ce0bbcd5b3e38"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "02d5aca1f1f02b8a7623289189fbebbe349db98f551b80afdf31371f37499472" => :big_sur
    sha256 "c9861f04884832a1b13f27ccc7eef8d96ad10d7b3637acbb077b7ff72e91e804" => :catalina
    sha256 "e858d99e9766b58afee79c9eabfed3145dd89afc06e786de4db87582878fefca" => :mojave
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
