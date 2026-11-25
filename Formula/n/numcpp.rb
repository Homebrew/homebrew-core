class Numcpp < Formula
  desc "C++ implementation of the Python Numpy library"
  homepage "https://dpilger26.github.io/NumCpp"
  url "https://github.com/dpilger26/NumCpp/archive/refs/tags/Version_2.18.0.tar.gz"
  sha256 "41af597c563ad1d094a21cb6c8147ff75ce8dc1ee0a9f829c704c0fd2388b180"
  license "MIT"
  head "https://github.com/dpilger26/NumCpp.git", branch: "master"

  bottle do
    manifest_sha256 "e6eadea70c93c4b43f39de2e9e9d8b1dd5fc6e49e256310f025cd9b15f499d96"
    sha256 cellar: :any_skip_relocation, all: "b898008a21d765e5da50b4090cd789fe2004d60f2785c379e5bc4d3067e8c8f6"
  end

  depends_on "cmake" => :build
  depends_on "boost" => :no_linkage

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <NumCpp.hpp>

      int main() {
          nc::NdArray<int> a = {{1, 2, 3}, {4, 5, 6}, {7, 8, 9}};
          a = nc::diagonal(a);
          for (int i = 0; i < nc::shape(a).cols; ++i)
              std::cout << a[i] << std::endl;
      }
    CPP

    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", "-I#{include}"
    assert_equal "1\n5\n9\n", shell_output("./test")
  end
end
