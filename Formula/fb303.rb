class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/v2023.01.02.00.tar.gz"
  sha256 "260cdac75d109ef042f6de145082f7b80d367b9947c2eb4f09446568efab9564"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d6b81ae85da85ae1d1c30c347112a75a3035fad582007ef45b3dc6d87a5afcc6"
    sha256 cellar: :any,                 arm64_monterey: "72b2fe09156c65e8edf75a5b76197d3e1b3801fe7b44ad5b541168a70a6b840a"
    sha256 cellar: :any,                 arm64_big_sur:  "c6a74eb5e7fb466d2a3823e78af6d033bfd8c2966952086e81b8614556f0ce79"
    sha256 cellar: :any,                 ventura:        "b58cf8bae3cdc4defd6f59d03bec3cbe913e0b86def81ac8bd832b87e4578092"
    sha256 cellar: :any,                 monterey:       "e560d37a4830ed83b3e3948bf5db2e8b62dd501d67a299edb200c053bf0e12c0"
    sha256 cellar: :any,                 big_sur:        "42290e42a33080883c3a4af3a6bec98f1df19f160fcca026546703008c9285fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b66e228d3ac8451515c97e4d969ba8ffb1ca0189d243c2cb7930567a6c83863e"
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
