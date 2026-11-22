class FastFloat < Formula
  desc "Fast and exact implementation of the C++ from_chars functions for number types"
  homepage "https://fastfloat.github.io/fast_float/"
  url "https://github.com/fastfloat/fast_float/archive/refs/tags/v8.4.0.tar.gz"
  sha256 "0bf4277827259720028bbef6c11d400f07482608bea5952b289baaef6af141a4"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/fastfloat/fast_float.git", branch: "main"

  bottle do
    manifest_sha256 "c41dc134963082cea33c636671bb817ad2528222b8c44822069ec8ba67610017"
    sha256 cellar: :any_skip_relocation, all: "1296d1443ca8a08240b162e8616b10410f5e053387dadf7e46b96007ab796c97"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test-fast-float.cc").write <<~CPP
      #include "fast_float/fast_float.h"
      #include <iostream>

      int main() {
          const std::string input =  "3.1416 xyz ";
          double result;
          auto answer = fast_float::from_chars(input.data(), input.data()+input.size(), result);
          if(answer.ec != std::errc()) { std::cerr << "parsing failure\\n"; return EXIT_FAILURE; }
          std::cout << "parsed the number " << result << std::endl;
          return EXIT_SUCCESS;
      }
    CPP

    ENV.append_to_cflags "-I#{include}"
    ENV.append "CXXFLAGS", "-std=c++11"

    system "make", "test-fast-float"
    output = shell_output("./test-fast-float")

    assert_match "parsed the number", output
    refute_match "parsing failure", output
  end
end
