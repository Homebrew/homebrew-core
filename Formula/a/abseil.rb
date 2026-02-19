class Abseil < Formula
  desc "C++ Common Libraries"
  homepage "https://abseil.io"
  url "https://github.com/abseil/abseil-cpp/archive/refs/tags/20260107.1.tar.gz"
  sha256 "4314e2a7cbac89cac25a2f2322870f343d81579756ceff7f431803c2c9090195"
  license "Apache-2.0"
  head "https://github.com/abseil/abseil-cpp.git", branch: "master"

  bottle do
    sha256                               arm64_tahoe:   "90697dc0727974c4a873ed19e63c30bc4c9525566cbd0ff968f980ce15047ae8"
    sha256                               arm64_sequoia: "5b62b81ba6ae8a78d728573226fb1d3abb14a14806e648dca9bfba84e77d5fb4"
    sha256                               arm64_sonoma:  "e8854f6a2420abecbbaa1c74bbebc2e5427e7688c35d370e88dd8e9620b37be0"
    sha256 cellar: :any,                 sonoma:        "e26f9da379d1a093b080e00ce65f550a8c1568edc2d66eec623ec3938fe0ea5f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33017a9d85883c652d83a8df3098066e3f482ec3c07d1247461587c9761df664"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df32cf7d435a18a293204adadceea594bc6c2889765d500d98acc7fb769671ac"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "googletest" => :build # For test helpers

  def install
    ENV.runtime_cpu_detection

    # Install test helpers.
    extra_cmake_args = %w[ABSL_BUILD_TEST_HELPERS ABSL_USE_EXTERNAL_GOOGLETEST ABSL_FIND_GOOGLETEST].map do |arg|
      "-D#{arg}=ON"
    end

    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DCMAKE_CXX_STANDARD=17",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DABSL_PROPAGATE_CXX_STD=ON",
                    "-DABSL_ENABLE_INSTALL=ON",
                    *extra_cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"hello_world.cc").write <<~CPP
      #include <iostream>
      #include <string>
      #include <vector>
      #include "absl/strings/str_join.h"

      int main() {
        std::vector<std::string> v = {"foo","bar","baz"};
        std::string s = absl::StrJoin(v, "-");

        std::cout << "Joined string: " << s << "\\n";
      }
    CPP
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.16)

      project(my_project)

      # Abseil requires C++14
      set(CMAKE_CXX_STANDARD 14)

      find_package(absl REQUIRED)

      add_executable(hello_world hello_world.cc)

      # Declare dependency on the absl::strings library
      target_link_libraries(hello_world absl::strings)
    CMAKE
    system "cmake", testpath
    system "cmake", "--build", testpath, "--target", "hello_world"
    assert_equal "Joined string: foo-bar-baz\n", shell_output("#{testpath}/hello_world")
  end
end
