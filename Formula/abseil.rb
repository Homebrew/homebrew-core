class Abseil < Formula
  desc "C++ Common Libraries"
  homepage "https://abseil.io"
  url "https://github.com/abseil/abseil-cpp/archive/20200923.2.tar.gz"
  sha256 "bf3f13b13a0095d926b25640e060f7e13881bd8a792705dd9e161f3c2b9aa976"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "ac18b6939251847cf870284e02b81a322b6eb1b52ed6309fdc54226a3826f8c4" => :catalina
    sha256 "83e37a50324358e6858db2420f5dad181fd36c9ef4c8133e6aafc5fbd429a8e3" => :mojave
    sha256 "3f25082bb450d9e81b7be69ec8f3d34ae05a68a6f94c1f48820be427aa18be1a" => :high_sierra
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
