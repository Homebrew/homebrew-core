class Abseil < Formula
  desc "C++ Common Libraries"
  homepage "https://abseil.io"
  url "https://github.com/abseil/abseil-cpp/archive/refs/tags/20220623.1.tar.gz"
  sha256 "91ac87d30cc6d79f9ab974c51874a704de9c2647c40f6932597329a282217ba8"
  license "Apache-2.0"
  head "https://github.com/abseil/abseil-cpp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d27a0ad54eb544a7f5a272cc1d3d50e6290660480a574b424c98db481107b620"
    sha256 cellar: :any,                 arm64_big_sur:  "641db05b2d660720d1b97d1ea9b93849fdf65941483871525707fb64c890bbfe"
    sha256 cellar: :any,                 monterey:       "cbbdfaa39842b6b483ce62c35e4315cdd0c2b9918ae92cf1fd46c02bcf1e4c34"
    sha256 cellar: :any,                 big_sur:        "e5b7f75a35bcbe0fa096396bd8d6c34a1b66564002dee8c599b6ac8559f73b29"
    sha256 cellar: :any,                 catalina:       "5fba2bd66821b5033f901918a15947fe28e1b4950a6742184e60d01cd45158dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60f232cba63cc45c520f74a64d50371d124862569a5718077da85b4385928e86"
  end

  depends_on "cmake" => :build

  fails_with gcc: "5" # C++17

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
