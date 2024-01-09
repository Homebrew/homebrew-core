class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/refs/tags/v2024.01.08.00.tar.gz"
  sha256 "b0b70695da62e3df1d2afd8b0d5ef58547960b92110dc3accb06e98c006d7704"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "66faaccc00b54886ab21f729d2e56cc4373cb1db61a414970cb870544d6bb073"
    sha256 cellar: :any,                 arm64_ventura:  "e31f3f6800ff5bbbc14974cff42c975406b4481a60ae5b06af825cd0578be360"
    sha256 cellar: :any,                 arm64_monterey: "85c1acaa53f1f8517776615d9d33051d22097a7e2ce46e0ec025c493c4a7e162"
    sha256 cellar: :any,                 sonoma:         "b97db7070bc51600770fd4d8d0cc97a290bd2246578f4d9ebfec2cd1cc9fc28a"
    sha256 cellar: :any,                 ventura:        "dd23bf03de9ff663524bb50aff095b2bb486d58e971c2233a0bf99a45c61c136"
    sha256 cellar: :any,                 monterey:       "8b5feca05f1d44769319cc42def9f70b7222d0fa132ded77e6c2cb8d56b031f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19ff7f3a9d2ff66e788b23addbf25191b95d6cf7032b5c1bc47a5afcc731d252"
  end

  depends_on "cmake" => :build
  depends_on "fbthrift" => [:build, :test]
  depends_on "mvfst" => :build
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libsodium"
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
