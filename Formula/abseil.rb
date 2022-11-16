class Abseil < Formula
  desc "C++ Common Libraries"
  homepage "https://abseil.io"
  url "https://github.com/abseil/abseil-cpp/archive/refs/tags/20220623.1.tar.gz"
  sha256 "91ac87d30cc6d79f9ab974c51874a704de9c2647c40f6932597329a282217ba8"
  license "Apache-2.0"
  head "https://github.com/abseil/abseil-cpp.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "da860134f8c93154324c1eb7ceac85224c8701e2a1758988ac9077778bebaa34"
    sha256 cellar: :any,                 arm64_monterey: "a684dd51320207ef4cd8134ab8e7e033fba14a7dc1d9f1c8cb1c4b770dc715ff"
    sha256 cellar: :any,                 arm64_big_sur:  "d31162eae71f007c10329296c0a646d6223d0f73e52d5fd8e2fc8333091ba377"
    sha256 cellar: :any,                 ventura:        "6733be2ec57587f9051b357999faa62a96c55fd4df75b6349a119a6e76bfc884"
    sha256 cellar: :any,                 monterey:       "41a3b0ca19070a90158beb85965e5485f116ad0e47b6c16ba9197c4324e5eab2"
    sha256 cellar: :any,                 big_sur:        "80a398e384146b1860a79d0ff6c0666de74aca714fef357b0cadf525bae2a289"
    sha256 cellar: :any,                 catalina:       "731fbe6746ab703ce4f6d17862de7ddb216b308d9d3948112c87ac0bfeb66d64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f35a7844efa0e3862361a1bbff49e4f65a1d5eb7bc1d77c82a526419eadc6d2d"
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
