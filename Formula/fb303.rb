class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/v2022.05.23.00.tar.gz"
  sha256 "9a54c358dd31bde025d8b3b655700a1e8f1eab262a23dc1e259aa4e38a095620"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ae97260e25ea6b87f0aee1eea497bb0faad94f8835bfa4bb7f9b8326e944b652"
    sha256 cellar: :any,                 arm64_big_sur:  "ee5fbaea23259b1662c5e02ad66080f83b35f91e034ff5a521f5bd443ba07485"
    sha256 cellar: :any,                 monterey:       "5c126c6d6149e7de0249745e619db49f0af3a629071b7ce51135db1d7201f30a"
    sha256 cellar: :any,                 big_sur:        "c9dcc6e14c88e5e8915d44b9878f1d7b377a57f9c4befedb1b63e735ec49f6ef"
    sha256 cellar: :any,                 catalina:       "01f03b85628002c9e336abab503ffa60e9b3e2b397f87e4f812e10d444885699"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7cd7450c354d19ffcfe805d76ef84362f57143baaafb094d7fbd4526321f88e5"
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
