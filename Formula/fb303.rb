class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/v2022.11.28.00.tar.gz"
  sha256 "b41bfe90d1c0ff010b24d73ec81474780e1f49449e49bfc85caae89e8166f6c0"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9e6c6ce8ad487477ba2628b7e4a5b5875aca53032df7c9354a05bc7c58e4f9cf"
    sha256 cellar: :any,                 arm64_monterey: "3811e4372d0f015b73dedf553bb13adf21ac64fd0b69384dfc4d8f7628090110"
    sha256 cellar: :any,                 arm64_big_sur:  "7a67198b32886f312b5dff0029e5c7abbf379cb31a7e254f3c7abfed414284cb"
    sha256 cellar: :any,                 ventura:        "1f36557157852d20e67ac1d33063c62f1b9a0494954840513b62207544c3058a"
    sha256 cellar: :any,                 monterey:       "311a65fddc6c600dd50f91f66094c494d54e270bb6a955062d2d267a6b525c66"
    sha256 cellar: :any,                 big_sur:        "e01124e1f102e709a415a00cadc02047cb556cef155e2af4f16b073010acb17d"
    sha256 cellar: :any,                 catalina:       "1a3508aabde296bfc62d8eb5d3cb845e7f974bca85d5330a3a94d87daf66d1a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "960c28464cfbce0d4f0770c7ff7ae6713c0986a748beac704678465043959d99"
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
