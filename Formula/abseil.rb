class Abseil < Formula
  desc "C++ Common Libraries"
  homepage "https://abseil.io"
  url "https://github.com/abseil/abseil-cpp/archive/20200225.2.tar.gz"
  sha256 "f41868f7a938605c92936230081175d1eae87f6ea2c248f41077c8f88316f111"

  bottle do
    cellar :any_skip_relocation
    sha256 "033a24ddaa7a21b2b4dcc4b94faf2f50659424ed23dbf7896ffed649251e6759" => :catalina
    sha256 "2a6d5775b666e089fe2626ce864b6ed360e23f79ed9a2efcc862927a38ae62d0" => :mojave
    sha256 "76522d0ca21e741f86ced9fa90d0d244a812cb1e099264541048d1f31993f2d8" => :high_sierra
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
