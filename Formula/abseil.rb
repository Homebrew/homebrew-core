class Abseil < Formula
  desc "C++ Common Libraries"
  homepage "https://abseil.io"
  url "https://github.com/abseil/abseil-cpp/archive/refs/tags/20230125.3.tar.gz"
  sha256 "5366d7e7fa7ba0d915014d387b66d0d002c03236448e1ba9ef98122c13b35c36"
  license "Apache-2.0"
  head "https://github.com/abseil/abseil-cpp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7c99fd26deff5a50c803f83454533f0123601f407dea0870c15250ec1666c78d"
    sha256 cellar: :any,                 arm64_monterey: "936ca2256b49815907e28351765ea3959ca3793fcc19747cf8a3fdd054b3fc03"
    sha256 cellar: :any,                 arm64_big_sur:  "09a43c1db5c5149754bd4a2d8f5e6444a529f7a8234bd17c313d2c1acec8ea09"
    sha256 cellar: :any,                 ventura:        "66f8baa97cc8c3a7eb3fff989e02cdd13898f61c1e3b113ad59d7ad2c084738d"
    sha256 cellar: :any,                 monterey:       "18410e6d4a3ae40b8e226207525f1284c21cff84eb8c3fcdf93f33ebb7aac22c"
    sha256 cellar: :any,                 big_sur:        "91b4acd428a79cfb9f67858cb20f3ab285825b05d2f49528ddbd168e9b199810"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc93de4047461611e6b0f73dc32eed30e9698ef13830e91eb0f7e475c5843951"
  end

  depends_on "cmake" => :build

  fails_with gcc: "5" # C++17

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DCMAKE_CXX_STANDARD=17",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DABSL_PROPAGATE_CXX_STD=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Remove bad flags in .pc files.
    # https://github.com/abseil/abseil-cpp/issues/1408
    if OS.mac?
      inreplace lib.glob("pkgconfig/absl_random_internal_randen_hwaes{,_impl}.pc"),
                "-Xarch_x86_64 -Xarch_x86_64 -Xarch_arm64 ", ""
    end
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <iostream>
      #include <string>
      #include <vector>
      #include "absl/strings/str_join.h"

      int main() {
        std::vector<std::string> v = {"foo","bar","baz"};
        std::string s = absl::StrJoin(v, "-");

        std::cout << "Joined string: " << s << "\\n";
      }
    EOS
    system ENV.cxx, "-std=c++17", "-I#{include}", "-L#{lib}", "-labsl_strings",
                    "test.cc", "-o", "test"
    assert_equal "Joined string: foo-bar-baz\n", shell_output("#{testpath}/test")
  end
end
