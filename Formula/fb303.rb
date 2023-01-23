class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/v2023.01.23.00.tar.gz"
  sha256 "bf55682ef609d2a4d894b993d0971b64db89b060cd49c05ad50f66637bf9737e"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c3e2902acfdf2f47a7ec95818f42a3664b19891dc4de074ba3e5fd7a12642854"
    sha256 cellar: :any,                 arm64_monterey: "515406cd000b153f235a861ac7a8b9f77a59a3c11c70a5176c076b7b2203a26f"
    sha256 cellar: :any,                 arm64_big_sur:  "0ccb451a32e419a75718f097287ed4ee922f415ffbba4bc3e4758beed909b090"
    sha256 cellar: :any,                 ventura:        "1c224d76424ea3098764c72756ff471067cd6a4dccdc94e0031842c8e7cbb3a5"
    sha256 cellar: :any,                 monterey:       "0a989485e1204c404f2fbe351ab01541c527b5f13eb8179682cd56d92f5e21d7"
    sha256 cellar: :any,                 big_sur:        "68e59c334f5f3884bf0759ad1c42913738a665a079b81ae116ed8388e9b25b53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5cd2dbbc7d4fd4ce0cec0ef88fda7bcc910ec625099b377092d645df10b34ac6"
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
