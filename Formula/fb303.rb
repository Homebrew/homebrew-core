class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/v2022.03.21.00.tar.gz"
  sha256 "23435e0af42bcfe4e244492b627e8cb30cf2d1e9dd8a7f891b947430b50ccd60"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ae998bc550d9583667860a91e48b9427d2b5f99287c85732ba4e69137e70de4b"
    sha256 cellar: :any,                 arm64_big_sur:  "8519430ae5dc9409ac92df6b1c7447f6bbbe51c33518557ce2994902f577db02"
    sha256 cellar: :any,                 monterey:       "9f1a1b6fff408fb96017a7b8e95bc5afb29b179dfc3e036dbfe882a9f4cffe4a"
    sha256 cellar: :any,                 big_sur:        "1f3576a93b6c0ad7dcf4f241e2007402bd6c446f8e638db18d54b45db26a9cd2"
    sha256 cellar: :any,                 catalina:       "47a121ee15b15e84776d3cf4ce9d621872d895585b04dcd77116fb05fe478353"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "518a4100d59f778f8350bb0460e819e70f40331a131103ea518b4965a7604e35"
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
