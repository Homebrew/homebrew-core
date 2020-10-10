class Abseil < Formula
  desc "C++ Common Libraries"
  homepage "https://abseil.io"
  url "https://github.com/abseil/abseil-cpp/archive/20200923.1.tar.gz"
  sha256 "808350c4d7238315717749bab0067a1acd208023d41eaf0c7360f29cc8bc8f21"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "41a1f8eaf020a761709b5d2c1d71d0d151d7f97dd85a9b06a8ac54fe2ffa5069" => :catalina
    sha256 "c5ed957360a25b35554b279530b21dbefcd2271e15df4ff3d436ff9a2de1ee0f" => :mojave
    sha256 "b07fe2fdca798d08e46cefedf3eea3d8d53fc6c6885cfd413cb4de3050f9bf04" => :high_sierra
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
