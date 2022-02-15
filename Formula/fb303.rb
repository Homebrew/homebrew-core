class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/v2022.02.14.00.tar.gz"
  sha256 "2f517506dc6cdf17bdbe4a2251be6c47eee77887650d83970741f2beee35743e"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c981cd86def0f0ada315d6ea8721870ffb065ae4d67c13269c09b19e55e8708a"
    sha256 cellar: :any,                 arm64_big_sur:  "84333295d301f125c62420fb63fbff807838b4d39ea3932fcfb6814e9be42a9a"
    sha256 cellar: :any,                 monterey:       "a486bce583dd2e9bc9c60a88c4d8a7aaea981d784943b127d7adf13f4b8270ff"
    sha256 cellar: :any,                 big_sur:        "ca2344f8ff9a647da30795323db1f5edff0a63de267f1d7de4c45efece866a3b"
    sha256 cellar: :any,                 catalina:       "9b6d179a753263d6af668c936b907c7e2b47f1e2aa8019da4bb4d17c4e404a58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1e6062de3d16996f9d5da46e2ae10c26730b2029657d8b2d18431a9afb3e034"
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
