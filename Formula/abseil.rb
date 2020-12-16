class Abseil < Formula
  desc "C++ Common Libraries"
  homepage "https://abseil.io"
  url "https://github.com/abseil/abseil-cpp/archive/20200923.2.tar.gz"
  sha256 "bf3f13b13a0095d926b25640e060f7e13881bd8a792705dd9e161f3c2b9aa976"
  license "Apache-2.0"
  revision 1

  bottle do
    cellar :any
    sha256 "cdc118ef74853d48c17c41e64da5c03b016249aaad0c1288bcd57685c3be3fea" => :big_sur
    sha256 "0571787ca3fd57f3b271c5944dafdf550f05a3dd5cc6e4f4ce820f9dff27b160" => :catalina
    sha256 "115c52f0799b9be98996b302c3906d230da318b0286694ef83bb90d603b1e432" => :mojave
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
