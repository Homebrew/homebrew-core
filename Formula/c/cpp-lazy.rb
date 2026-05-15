class CppLazy < Formula
  desc "C++11 (and onwards) library for lazy evaluation"
  homepage "https://github.com/Kaaserne/cpp-lazy"
  url "https://github.com/Kaaserne/cpp-lazy/archive/refs/tags/v9.0.1.tar.gz"
  sha256 "16cbaf58002ed46d369e8b87df4ac4b1fc47265fdffed0c5009b3ff8c7f013db"
  license "MIT"
  head "https://github.com/Kaaserne/cpp-lazy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a6189f64f50809a62082509f85a970ade5984a5b7c4ef229aece0cf8e3f9b23b"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test
  depends_on "fmt"

  def install
    args = %w[
      -DCPP-LAZY_USE_STANDALONE=ON
      -DCPP_LAZY_USE_INSTALLED_FMT=ON
      -DCPP_LAZY_INSTALL=ON
    ]
    system "cmake", "-S", ".", "-B", "builddir", *args, *std_cmake_args
    system "cmake", "--build", "builddir"
    system "cmake", "--install", "builddir"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <array>
      #include <iostream>
      #include <sstream>

      #include "Lz/map.hpp"

      int main() {
        std::array<int, 4> arr = {1, 2, 3, 4};
        auto map = lz::map(arr, [](int i) { return i + 1; });

        std::ostringstream oss;
        for (auto it = map.begin(); it != map.end(); ++it) {
          if (it != map.begin()) oss << ' ';
          oss << *it;
        }
        std::cout << oss.str() << std::endl; // == "2 3 4 5"
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++20", "-o", "test"
    assert_match "2 3 4 5", shell_output("./test")
  end
end
