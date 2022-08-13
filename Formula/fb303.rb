class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/v2022.08.08.00.tar.gz"
  sha256 "5235b7c96a72c40b081a2a8cb6f4fd61b03e0f3d868ea34a417456bb210e562a"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "56f21b8c05248f62e78d08540dd20ebd4c25de7bb3e48a66a8335753580e976b"
    sha256 cellar: :any,                 arm64_big_sur:  "1db7e106127e181262dbc163570ca7f8bff14817368f9f5673318e920ec27033"
    sha256 cellar: :any,                 monterey:       "7546353b4f34e06a55d01fd6c3cf40e71d7acb37fd9a8bbab8ed5b526272e3cd"
    sha256 cellar: :any,                 big_sur:        "693bf6d2dca38bf0825a99da1d0ef9710b40cbdeb930dfd0fa60b06dd707e316"
    sha256 cellar: :any,                 catalina:       "ebc33dfc6e53418ee5144be8058bf7101e55aa500f7d66af0d90b39c3be29879"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a59a140acb171dc350029d2dc067945e4cc79fa1eb73909f730c88593b866c7"
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
