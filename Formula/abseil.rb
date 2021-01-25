class Abseil < Formula
  desc "C++ Common Libraries"
  homepage "https://abseil.io"
  url "https://github.com/abseil/abseil-cpp/archive/20200923.3.tar.gz"
  sha256 "ebe2ad1480d27383e4bf4211e2ca2ef312d5e6a09eba869fd2e8a5c5d553ded2"
  license "Apache-2.0"

  bottle do
    sha256 "e16d12f4d5eb788fc774d1cc6d328a659bfc56f0cef74244396f2453890bb9ed" => :big_sur
    sha256 "0b4448de8c7a176da27c895da37c7edbadabd304a2d5ddb76c7d134f7b130e4d" => :arm64_big_sur
    sha256 "648a6091da13e90637b3579249ae8821292ca96efb95cd1d4a5a649d553c6ef6" => :catalina
    sha256 "0879e0af3745923b219e99af5355100a4a8e4c944167414e038633a6779736d0" => :mojave
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
