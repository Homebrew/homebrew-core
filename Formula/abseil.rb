class Abseil < Formula
  desc "C++ Common Libraries"
  homepage "https://abseil.io"
  url "https://github.com/abseil/abseil-cpp/archive/20200923.3.tar.gz"
  sha256 "ebe2ad1480d27383e4bf4211e2ca2ef312d5e6a09eba869fd2e8a5c5d553ded2"
  license "Apache-2.0"

  bottle do
    sha256 "fa79730a5856560ccba352aa29cba48d74e80392b4cec9d86c22d2301f0109d8" => :big_sur
    sha256 "27e532ad8f8cb95daa149b59bb536c8576ff43a3818ffe4612d4f9ce92f81a37" => :arm64_big_sur
    sha256 "ee1b6459287b0207aad007be9aea3fc78d04ca9e381eda6eed2772e40eeb5dd7" => :catalina
    sha256 "c6770d5ad076e5aea441ce4536e5aba065cac5a5aa515ee9b5eae6fc4cdbf21c" => :mojave
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
