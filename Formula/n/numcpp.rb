class Numcpp < Formula
  desc "C++ implementation of the Python Numpy library"
  homepage "https://dpilger26.github.io/NumCpp"
  url "https://github.com/dpilger26/NumCpp/archive/refs/tags/Version_2.13.0.tar.gz"
  sha256 "930c8c433c4cd4322ea4a3f42b06453e5c1586a4210aeff603eaae180b228457"
  license "MIT"
  head "https://github.com/dpilger26/NumCpp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fb73c57557420b7c0449d8b91259043af80bc84e005792fd2ee735ef72148f52"
  end

  depends_on "cmake" => :build
  depends_on "boost"

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
