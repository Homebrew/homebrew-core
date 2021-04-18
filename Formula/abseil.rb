class Abseil < Formula
  desc "C++ Common Libraries"
  homepage "https://abseil.io"
  url "https://github.com/abseil/abseil-cpp/archive/20210324.0.tar.gz"
  sha256 "dd7db6815204c2a62a2160e32c55e97113b0a0178b2f090d6bab5ce36111db4b"
  license "Apache-2.0"
  head "https://github.com/abseil/abseil-cpp.git"

  bottle do
    sha256 arm64_big_sur: "b0ac0ff75bf1d9d81ffc8be51ed7d04d773b294f4b4f2ebb2a2d1bd4e8d05dc2"
    sha256 big_sur:       "3498c9abb8b6ef72700b63604caf8597caa6281d7ac324d9f7ae5e7ae7fd7cb0"
    sha256 catalina:      "e27ffdb0329487136a912ad4b5d5a3e2d850e294544aa400a133d50744283505"
    sha256 mojave:        "60698d41a284bbd52a7cc371f3e39114079923e855e80713650bfa1edb023f18"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..",
                      *std_cmake_args,
                      "-DCMAKE_INSTALL_RPATH=#{rpath}",
                      "-DCMAKE_CXX_STANDARD=17",
                      "-DBUILD_SHARED_LIBS=ON"
      system "make"
      system "make", "install"
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
