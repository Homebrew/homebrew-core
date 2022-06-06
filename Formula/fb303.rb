class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/v2022.06.06.00.tar.gz"
  sha256 "e361a38dd45ce32998fb6769168dc11b242a5d9ea57d5be50fb97ba5359e7a8d"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e0d7749b89c0f3f92b951e80b5bb90012d837f2e3066c907eb66c0fee8b762d7"
    sha256 cellar: :any,                 arm64_big_sur:  "807f7e4f3a9e535e302ca7719d63b0a65c9fa6f4b76c29961eabac4e578ab125"
    sha256 cellar: :any,                 monterey:       "77fe908a4772095010a839c326067f653162d4d13248b0d0b2fcefacaa7a03b0"
    sha256 cellar: :any,                 big_sur:        "c90c4375829e4f98479249348994e64511fac53071898a18d8b5a2251b67e196"
    sha256 cellar: :any,                 catalina:       "de4e91e219b74c3866d8dc889c1d33f9e36074e106f36660192aa436c981d04a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a17082ecef8e32b4a2817fbed781f069d06d018dc76b0b09e3747dfde80e5b84"
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
