class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/v2022.12.26.00.tar.gz"
  sha256 "e997d1c79f9424f2d264bc3381c52ca0477090cfe3909a4f3b6a3d90afbaa580"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7f5487e061707dc3686fa10b5b2bfee93ac9528ebe9411da88cce44b0f424123"
    sha256 cellar: :any,                 arm64_monterey: "2090ee1a64e07445fd2bf7eca01320795ccc8934ed8acf066b987ba5e88e66a6"
    sha256 cellar: :any,                 arm64_big_sur:  "a43706ba0ca1b5605569528ad3ae5ffcd37fd10ba44f3d9913625405e74cf182"
    sha256 cellar: :any,                 ventura:        "ebe6106060aede0b54b941128237cd38f5b029dc65c3be1b1a2e87001bda7741"
    sha256 cellar: :any,                 monterey:       "190bc2152b65ca8fd13931081e54313370ebf9c8b05368b346f6853baaeb9bab"
    sha256 cellar: :any,                 big_sur:        "dba343b9919e5cddddd00388e1c1f9c36d8da6f5ce2c4f5293c52e92510b8bb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d3c924479289fdef9ace5116a243bf55cfdbb7024ac561f477651a60ebaf544"
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
