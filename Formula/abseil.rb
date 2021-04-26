class Abseil < Formula
  desc "C++ Common Libraries"
  homepage "https://abseil.io"
  url "https://github.com/abseil/abseil-cpp/archive/20210324.1.tar.gz"
  sha256 "441db7c09a0565376ecacf0085b2d4c2bbedde6115d7773551bc116212c2a8d6"
  license "Apache-2.0"
  head "https://github.com/abseil/abseil-cpp.git"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "ad68ce866850cfc0f8480a35776aea144d845ae15dad8078f440ed75086b06c9"
    sha256 cellar: :any, big_sur:       "c9c41cec6d66ea22de32af15521a394fe62fa9607518a59c71ae065293063935"
    sha256 cellar: :any, catalina:      "a6ba94bc57bc38aebf49794fdfc43ecede6d6f7220da5e2e4e2cda7c86c32c72"
    sha256 cellar: :any, mojave:        "3307f91e4fca0915eb0b918a3e6beb90dd463904b157a3b4ef3f2481dfc4d698"
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
