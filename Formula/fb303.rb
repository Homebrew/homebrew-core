class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/v2022.10.17.00.tar.gz"
  sha256 "b4acbc00ccc627fd3b61d97d0c4b8a9909528f52313034c1739bbe2332f5afb1"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4430b18002859c982fad435d22459a3e1cfcf0d4d4a71869c7ac755e5ad0ee63"
    sha256 cellar: :any,                 arm64_big_sur:  "cf31237b6606ab06a280454f3bc14d52f31b0b0b3ffd5ca2697b95607fd829a8"
    sha256 cellar: :any,                 monterey:       "f659e0c102a51a625ef9318f58a82a606aba0dae064a2ecb86570f6eedc1e6e2"
    sha256 cellar: :any,                 big_sur:        "fda47c52692435b91da71a535bca13e632f78ba04b672b51b35340cbe666d195"
    sha256 cellar: :any,                 catalina:       "b3acb2ecc36b71abe76554b4e55f601c1d3688745a07307d03e3d1fbfe054f48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "254faa3e2a6bb36467c7f74e03b73103034b8e6e3e821c189256e287f4c2aeca"
  end

  depends_on "cmake" => :build
  depends_on "fbthrift"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@1.1"
  depends_on "wangle"

  fails_with gcc: "5" # C++17

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXTENSIONS=OFF",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
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
                    "-I#{include}", "-I#{Formula["openssl@1.1"].opt_include}",
                    "-L#{lib}", "-lfb303_thrift_cpp",
                    "-L#{Formula["folly"].opt_lib}", "-lfolly",
                    "-L#{Formula["glog"].opt_lib}", "-lglog",
                    "-L#{Formula["fbthrift"].opt_lib}", "-lthriftprotocol", "-lthriftcpp2",
                    "-L#{Formula["boost"].opt_lib}", "-lboost_context-mt",
                    "-ldl"
    assert_equal "BaseService", shell_output("./test").strip
  end
end
