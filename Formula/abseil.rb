class Abseil < Formula
  desc "C++ Common Libraries"
  homepage "https://abseil.io"
  url "https://github.com/abseil/abseil-cpp/archive/20200923.2.tar.gz"
  sha256 "bf3f13b13a0095d926b25640e060f7e13881bd8a792705dd9e161f3c2b9aa976"
  license "Apache-2.0"
  revision 4

  bottle do
    cellar :any
    sha256 "eca91cdd1c34992498be4e66835e28f207d53fff3f0d4134b33064ff35b2d295" => :big_sur
    sha256 "4d318e65276877eb1e1fd8a6b2b9dbe404820a7047335e92614c3d1cbc362e4f" => :catalina
    sha256 "ef95ef36dbaecce52bf3c3bc4118badb729ca633080db11f112a13afb3f63c72" => :mojave
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..",
                      *std_cmake_args,
                      "-DCMAKE_INSTALL_RPATH=#{lib}",
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
