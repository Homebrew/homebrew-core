class Abseil < Formula
  desc "C++ Common Libraries"
  homepage "https://abseil.io"
  url "https://github.com/abseil/abseil-cpp/archive/20200923.1.tar.gz"
  sha256 "808350c4d7238315717749bab0067a1acd208023d41eaf0c7360f29cc8bc8f21"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "66b9e248e36aadbb9984eb33bfb126848b9ea7bf6ca4f6baf4fb7b4a72c39cf8" => :catalina
    sha256 "4cf99f39a5d99282c289986562bc125892e2610bc1fe6b82f38d300b4254939d" => :mojave
    sha256 "3a50cb0ccab4b65f8e98607f070105e6f6cdd6fda6770674bfc146bc8e3234e2" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    ENV.cxx11

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
