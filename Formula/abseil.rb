class Abseil < Formula
  desc "C++ Common Libraries"
  homepage "https://abseil.io"
  url "https://github.com/abseil/abseil-cpp/archive/refs/tags/20220623.1.tar.gz"
  sha256 "91ac87d30cc6d79f9ab974c51874a704de9c2647c40f6932597329a282217ba8"
  license "Apache-2.0"
  head "https://github.com/abseil/abseil-cpp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0055d33f047cc5b840cecc5a914fbeaa2b9ab88bd17d8d37bc4fd6e0ff2ccf27"
    sha256 cellar: :any,                 arm64_big_sur:  "131fc67a76243ecd760cf20457de8952649677e4eedf44f20fe5ae613120c18e"
    sha256 cellar: :any,                 monterey:       "24bfd83bbae83e0562e3798e8b86a98f274acfbd456b8836bfb9d2e4b75dfdec"
    sha256 cellar: :any,                 big_sur:        "d694723ee65f04c8727035f49c36ecf1f7fcbe36e5833fd27f5d7d88594a445b"
    sha256 cellar: :any,                 catalina:       "9b5cf436cb57b35260fc2a0d7182259fa9351893be591ee570731d1600d4678b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84a1f15dd86c0ac02ceb06eca0a01fceeaab04c731a31c925b2d40d5d7b2031f"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "gcc"
  end

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
