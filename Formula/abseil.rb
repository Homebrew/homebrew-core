class Abseil < Formula
  desc "C++ Common Libraries"
  homepage "https://abseil.io"
  url "https://github.com/abseil/abseil-cpp/archive/refs/tags/20230125.1.tar.gz"
  sha256 "81311c17599b3712069ded20cca09a62ab0bf2a89dfa16993786c8782b7ed145"
  license "Apache-2.0"
  head "https://github.com/abseil/abseil-cpp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "fa0b75319f9699720edd3f7ab18ab3106dfd28f82739e22c0f0d9e25faaeb32d"
    sha256 cellar: :any,                 arm64_monterey: "e5bb53ed283a441548331d3de02d0258359a4b89fe36b8aa945923307fd53f1b"
    sha256 cellar: :any,                 arm64_big_sur:  "abf21c9625cbd42535ed005de64be2c2d6ac534e0de7c7f7d4c5bcdde1625b02"
    sha256 cellar: :any,                 ventura:        "306df33feb8d35d0ac341db33c4c9ac36ca8886de300cf3e34551140d5fede5b"
    sha256 cellar: :any,                 monterey:       "b368a41757d986a2ed34f55ac80555445a7c0d35b5f55ba26ec8cfb242eeb20f"
    sha256 cellar: :any,                 big_sur:        "6a80a4248e7e9c0491c1d06d0e2ff1b6224f9dabbe6f1c31e2f3bbbc215b9ee0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "722649548a9d355499bc452c95bdfa71809b1f84df048776537dde787e771709"
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
