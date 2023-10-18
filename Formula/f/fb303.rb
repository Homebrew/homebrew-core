class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/refs/tags/v2023.10.09.00.tar.gz"
  sha256 "89ce340f9decaa6eb20922d6e8b90ec00ad1f6faf7006e0b39c698723d4a4c40"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a1680e88c940920a10ce4a158acbbc5faadaf190a2b9ccaac79c3ab7e5636c6b"
    sha256 cellar: :any,                 arm64_ventura:  "b8b187b8cf4c85d89d89c363fbd8ccf867c0a98d7598c8b054a9bd2e30715b5f"
    sha256 cellar: :any,                 arm64_monterey: "d3eff22269c14a1fb9a149b308dabfc7be0d56fddbbba6a0c117f37051791575"
    sha256 cellar: :any,                 sonoma:         "470e3344e6a5e4d96c2a151c25f82d573b27180cfff2fb4c14ba49e94de5790f"
    sha256 cellar: :any,                 ventura:        "5ceba84d1a6698d923194e2cd70b56f3b3e2a7c5680baa5610fd38694720be5b"
    sha256 cellar: :any,                 monterey:       "120a60d4a567dd29dba1b597fbd8396c1aaeaf0c8db9fc828688079673fab6f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b02a063a037e9fcbbd350e938cc22ca79a24ff0cf61cd39e4a256a3d5f35feb"
  end

  depends_on "cmake" => :build
  depends_on "mvfst" => :build
  depends_on "fbthrift"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@3"
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
