class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/v2022.06.06.00.tar.gz"
  sha256 "e361a38dd45ce32998fb6769168dc11b242a5d9ea57d5be50fb97ba5359e7a8d"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "da39031a780c6215806fbd36f27acc011ec3ece6dfd67a623a8b7b92dbcf3bb1"
    sha256 cellar: :any,                 arm64_big_sur:  "4ffa95954d9edb02829e4fb28f5a41da2ac45b7701da24f44aedbb7dce229dd1"
    sha256 cellar: :any,                 monterey:       "6ba6f0e6c06072852938a65a62a136df67d22c1daedafe54e8ad113adf3a85ee"
    sha256 cellar: :any,                 big_sur:        "c3f5bd4c97475686f27a8e9749011de610931c7863fa1de210d9dad26df026c9"
    sha256 cellar: :any,                 catalina:       "1e05167f5d6d7bf18394e43060674899e303b5f4d9a98be31882d524e9eb61c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa4d81f6e19e0bc3da5f4be4d39c9422074e91761a50df0365716d7f7877ac61"
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

  on_linux do
    depends_on "gcc"
  end

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
    system ENV.cxx, "-std=c++17", "-I#{include}", "-I#{Formula["openssl@1.1"].opt_include}", "test.cpp",
                    "-L#{Formula["folly"].opt_lib}", "-lfolly", "-L#{Formula["glog"].opt_lib}", "-lglog",
                    "-L#{lib}", "-lfb303_thrift_cpp", "-L#{Formula["boost"].opt_lib}", "-lboost_context-mt",
                    "-ldl", "-L#{Formula["fbthrift"].opt_lib}", "-lthriftprotocol", "-o", "test"
    assert_equal "BaseService", shell_output("./test").strip
  end
end
