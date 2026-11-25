class MagicEnum < Formula
  desc "Static reflection for enums (to string, from string, iteration) for modern C++"
  homepage "https://github.com/Neargye/magic_enum"
  url "https://github.com/Neargye/magic_enum/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "931ff9bc24e6e0712d524692dc95943b2679048be7e1732b9637134f6f2a58c1"
  license "MIT"
  compatibility_version 1

  bottle do
    manifest_sha256 "ce09fc04f6b54a808650f6a17bd9fd998810af0796215c884f7a0f5c40139c72"
    sha256 cellar: :any_skip_relocation, all: "0bc67beaf8a9438984f44f5cd869218b9b842682e73718c75105739577e9e86a"
  end

  depends_on "cmake" => :build

  deny_network_access!

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
