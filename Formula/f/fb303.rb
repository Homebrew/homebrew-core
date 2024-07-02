class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/refs/tags/v2024.07.01.00.tar.gz"
  sha256 "91dc419bed9fa2cc9093172cd28414f432117a4ef59197328979432894284225"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c8c0f105bfaf997f153eee0d4c0d6a3888e623433baad1186c2b91d5c37d142d"
    sha256 cellar: :any,                 arm64_ventura:  "6a85b8e7992d32cddbdf3effb3843149e19837d0e49636da155d81c7a022b414"
    sha256 cellar: :any,                 arm64_monterey: "afd1b2da10fe8c59efb906647679b81f1191c18b2b9474a7e1ab0eb37e7e59aa"
    sha256 cellar: :any,                 sonoma:         "3b6d91fec9c683f06693f74011f549d35d0747c03554c23c1abcf7819eaeb6c4"
    sha256 cellar: :any,                 ventura:        "119dca0a6d66bd9f04ea1ea313d9cd204f5eb96af68478e7ff62af77bac65362"
    sha256 cellar: :any,                 monterey:       "4d599cfafff5ab1c718057836b14d7d6fe37d067c51f39a44c094fbd6b468236"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d2f146a1a738c5de83b5fb093876b2f5da412cc0e423329bfa918133162db70"
  end

  depends_on "cmake" => :build
  depends_on "fbthrift"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@3"

  fails_with gcc: "5" # C++17

  def install
    shared_args = ["-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
    shared_args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", "-DPYTHON_EXTENSIONS=OFF", *shared_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "fb303/thrift/gen-cpp2/BaseService.h"
      #include <iostream>
      int main() {
        auto service = facebook::fb303::cpp2::BaseServiceSvIf();
        std::cout << service.getGeneratedName() << std::endl;
        return 0;
      }
    EOS

    if Tab.for_formula(Formula["folly"]).built_as_bottle
      ENV.remove_from_cflags "-march=native"
      ENV.append_to_cflags "-march=#{Hardware.oldest_cpu}" if Hardware::CPU.intel?
    end

    ENV.append "CXXFLAGS", "-std=c++17"
    system ENV.cxx, *ENV.cxxflags.split, "test.cpp", "-o", "test",
                    "-I#{include}", "-I#{Formula["openssl@3"].opt_include}",
                    "-L#{lib}", "-lfb303_thrift_cpp",
                    "-L#{Formula["folly"].opt_lib}", "-lfolly",
                    "-L#{Formula["glog"].opt_lib}", "-lglog",
                    "-L#{Formula["fbthrift"].opt_lib}", "-lthriftprotocol", "-lthriftcpp2",
                    "-L#{Formula["boost"].opt_lib}", "-lboost_context-mt",
                    "-ldl"
    assert_equal "BaseService", shell_output("./test").strip
  end
end
