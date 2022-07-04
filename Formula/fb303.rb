class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/v2022.07.04.00.tar.gz"
  sha256 "7024be76f181559da406f8751784f8fef46b3583089d48b3bf996b4342b0f50c"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a9aa969f89267383df0f12a3beb98f1dbcbedcd6a4af37baf2927ccbcc3aa333"
    sha256 cellar: :any,                 arm64_big_sur:  "2dcab6f4c90ac4d520b415f2cd8fd4496a1a60cc5ebc8a0722313d7e238dff1e"
    sha256 cellar: :any,                 monterey:       "71ec925535d7a9fc4a3db4db8e744945a505e7ffb1f618e2d79490292c4a8485"
    sha256 cellar: :any,                 big_sur:        "70aaddf2a0180059d06374ac9163d58bb5630113c996e5934cba870a07235030"
    sha256 cellar: :any,                 catalina:       "5b71799a074a657975a716d7650446f7131cf5d1fd6229fa34f5ad21d9c0019f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28e3c367dd89595c68b47925d25d8e2b06fa6e436f4846fe41a57b61363b3c6a"
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
