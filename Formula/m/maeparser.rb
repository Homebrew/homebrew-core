class Maeparser < Formula
  desc "Maestro file parser"
  homepage "https://github.com/schrodinger/maeparser"
  url "https://github.com/schrodinger/maeparser/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "a8d80f67d1b9be6e23b9651cb747f4a3200132e7d878a285119c86bf44568e36"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3a7ea0e057badfd3c4152ee82c7a168756fdf69a7ba860c52e76b54ee14db3b0"
    sha256 cellar: :any,                 arm64_sonoma:  "ca02271a309d8c6d442671b396fedc2be05915a787097c5a797313c3afbb2fea"
    sha256 cellar: :any,                 arm64_ventura: "442e30300805148e962404029bddd1e5f3e2ced2b7da2629ca5db952336bc6ad"
    sha256 cellar: :any,                 sonoma:        "c64fc931d98a6ae27cb9dc243ac3a52d4cd2f4ad74d6c6a7a9ff60674db90479"
    sha256 cellar: :any,                 ventura:       "6174e8874ad30e0bbb991dc2dd52e9e9caca66f54680a0f8a3088294c7ba1c9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f31191fad40b78f8639deab22940717e01af49c477b0429b6f52c77e5575d5ef"
  end

  depends_on "cmake" => :build
  depends_on "boost"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DMAEPARSER_BUILD_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "test/MainTestSuite.cpp", "test/UsageDemo.cpp", "test/test2.maegz"
  end

  test do
    cp pkgshare.children, testpath
    system ENV.cxx, "-std=c++11", "MainTestSuite.cpp", "UsageDemo.cpp", "-o", "test",
                    "-DTEST_SAMPLES_PATH=\"#{testpath}\"", "-DBOOST_ALL_DYN_LINK",
                    "-I#{include}/maeparser", "-L#{lib}", "-lmaeparser",
                    "-L#{Formula["boost"].opt_lib}", "-lboost_filesystem", "-lboost_unit_test_framework"
    system "./test"
  end
end
