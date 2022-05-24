class MagicEnum < Formula
  desc "Static reflection for enums (to string, from string, iteration) for modern C++"
  homepage "https://github.com/Neargye/magic_enum"
  url "https://github.com/Neargye/magic_enum/archive/v0.8.0.tar.gz"
  sha256 "5e7680e877dd4cf68d9d0c0e3c2a683b432a9ba84fc1993c4da3de70db894c3c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "07022b1fd8eb28262c459799bc3c5b01bb73306790dd6cb8c530a73dc5c3ec28"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "gcc" # C++17
  end

  fails_with gcc: "5"

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
