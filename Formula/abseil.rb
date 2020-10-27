class Abseil < Formula
  desc "C++ Common Libraries"
  homepage "https://abseil.io"
  url "https://github.com/abseil/abseil-cpp/archive/20200923.2.tar.gz"
  sha256 "bf3f13b13a0095d926b25640e060f7e13881bd8a792705dd9e161f3c2b9aa976"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "427d76ee4e58414546725bab7720284f0e513fa4317c4259ad1a4ffdc1f6be56" => :catalina
    sha256 "60c98f7731cf9de032fe54a3691f648908f12ae462590b1e0a99e607abe5b939" => :mojave
    sha256 "ad2c933b411cbfc06f39e6abed04f26522d7ea9eaea9bf47887a0eca7c6754c7" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DCMAKE_CXX_STANDARD=17"
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
