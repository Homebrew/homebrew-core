class Abseil < Formula
  desc "C++ Common Libraries"
  homepage "https://abseil.io"
  url "https://github.com/abseil/abseil-cpp/archive/20200923.2.tar.gz"
  sha256 "bf3f13b13a0095d926b25640e060f7e13881bd8a792705dd9e161f3c2b9aa976"
  license "Apache-2.0"
  revision 3

  bottle do
    cellar :any
    sha256 "e85bf140deff10111683259ffd90484216081267eeb4df3a321cc9ca39d7e98d" => :big_sur
    sha256 "76de6f16ec4a42288f0dfcd9d8ad4b1c57cc8e77b1f276130094f8d5314ee2c5" => :catalina
    sha256 "0341ffa04caebe6633c284a5a8e7c1015ddebd648cd108879b4af7de403901d9" => :mojave
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..",
                      *std_cmake_args,
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
