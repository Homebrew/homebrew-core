class Abseil < Formula
  desc "C++ Common Libraries"
  homepage "https://abseil.io"
  url "https://github.com/abseil/abseil-cpp/archive/refs/tags/20230125.2.tar.gz"
  sha256 "9a2b5752d7bfade0bdeee2701de17c9480620f8b237e1964c1b9967c75374906"
  license "Apache-2.0"
  head "https://github.com/abseil/abseil-cpp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8a90edaad067da0ef555dff0383f69a6fab7f9bcaeeaf5daa93d33a7af3dba4a"
    sha256 cellar: :any,                 arm64_monterey: "3a9b491c52bb3492f35b6470af5e95869ebb3b46a2f66054022da8995582970e"
    sha256 cellar: :any,                 arm64_big_sur:  "3c2001f52fe980e16f2ec4b57f7ffcd9ce66a73c53c33ed0374b88833aeecc91"
    sha256 cellar: :any,                 ventura:        "aa30d047ccacc77014e26865db978e157513acb200a8be24bdd14cf86f4de268"
    sha256 cellar: :any,                 monterey:       "dc920a2b452d6482f715fa6172e0fd83a129f40f127076bf8f936e408e20711e"
    sha256 cellar: :any,                 big_sur:        "53e93bef633d2bd4fc93dcc8acc82bd3adf34769755694efd52025b939a1e65b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ecb338097ce064c52f373081c590396cdc0f5acb5206b86655ea2e4e146ac10"
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
