class Gcem < Formula
  desc "C++ compile-time math library"
  homepage "https://gcem.readthedocs.io/en/latest/"
  url "https://github.com/kthohr/gcem/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "8e71a9f5b62956da6c409dda44b483f98c4a98ae72184f3aa4659ae5b3462e61"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/kthohr/gcem.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "9922cb2ea8c9e1410e66b74c11d2f9e5dbcb44670f96603594c63cf705d8d444"
  end

  depends_on "cmake" => :build

  # Fix CMake 4.x compatibility
  patch do
    url "https://github.com/kthohr/gcem/commit/e9c2cc8e656e7a346cb225e91ee86394f0807415.patch?full_index=1"
    sha256 "60bc1782d8e8a431bee0f639154a9d83da83f7994f7c380a6de857c61ee9160a"
    type :unofficial
    resolves "https://github.com/kthohr/gcem/issues/50"
  end

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <gcem.hpp>

      int main() {
        constexpr int x = 10;
        std::cout << gcem::factorial(x) << std::endl;
        return 0;
      }
    CPP

    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}", "-o", "test"
    assert_equal "3628800\n", shell_output("./test")
  end
end
