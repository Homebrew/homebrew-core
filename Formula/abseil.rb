class Abseil < Formula
  desc "C++ Common Libraries"
  homepage "https://abseil.io"
  url "https://github.com/abseil/abseil-cpp/archive/20200225.2.tar.gz"
  sha256 "f41868f7a938605c92936230081175d1eae87f6ea2c248f41077c8f88316f111"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "43368dc236c3e6371d904edda75e5a8dae8127ded5b2f9ff9a0a15b4ddf103d0" => :catalina
    sha256 "68ed0a482bd727a10fc0cf2e2e76c0307dc2d5eba8c9e4a2c0990a1dc68825b9" => :mojave
    sha256 "bed9e2b638d6c044d31fe88bd04b225eb33548650890084ebb0657a574f7fcee" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
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
    system ENV.cxx, "-std=c++11", "-I#{include}", "-L#{lib}", "-labsl_strings",
                    "test.cc", "-o", "test"
    assert_equal "Joined string: foo-bar-baz\n", shell_output("#{testpath}/test")
  end
end
