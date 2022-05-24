class Abseil < Formula
  desc "C++ Common Libraries"
  homepage "https://abseil.io"
  url "https://github.com/abseil/abseil-cpp/archive/refs/tags/20211102.0.tar.gz"
  sha256 "dcf71b9cba8dc0ca9940c4b316a0c796be8fab42b070bb6b7cab62b48f0e66c4"
  license "Apache-2.0"
  head "https://github.com/abseil/abseil-cpp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0c19e80720547d2ef348842242568e27bbc662f4be6b4dc4b40a7477645b9dbf"
    sha256 cellar: :any,                 arm64_big_sur:  "23ad9b293aad20112786ec85f80a54781edb42081277e18bbda61752965b1301"
    sha256 cellar: :any,                 monterey:       "a890728e03ba9359d371d55430ca1b86e4b7c28420179b6d05ae4fed2134b966"
    sha256 cellar: :any,                 big_sur:        "c707d13cb25a75e52333bcbd57e17f522e09e5f073302ce904d61ec026ccd708"
    sha256 cellar: :any,                 catalina:       "9a2c8277e6d4b348914220580486bf707b2e09d70f6457a60496cc4254426875"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "513087011325dd2d8a006ba7d12c07e6077dc9048fed2d5e36d20c0905681c81"
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
