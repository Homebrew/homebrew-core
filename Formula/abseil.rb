class Abseil < Formula
  desc "C++ Common Libraries"
  homepage "https://abseil.io"
  url "https://github.com/abseil/abseil-cpp/archive/20190808.tar.gz"
  sha256 "8100085dada279bf3ee00cd064d43b5f55e5d913be0dfe2906f06f8f28d5b37e"

  bottle do
    cellar :any_skip_relocation
    sha256 "9916569392f5088ac2c252e6d8741a933c1c10a20de248b7da00b659dc3f28ed" => :catalina
    sha256 "168ecfe15881546af5d1171da700e27607f0393bc5015dd85695581369e28bae" => :mojave
    sha256 "5a422984a498f6b852a2f15cfd1a2ded24b40048bf8fe59d21791ab41b6293fe" => :high_sierra
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
