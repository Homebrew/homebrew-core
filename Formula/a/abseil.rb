class Abseil < Formula
  desc "C++ Common Libraries"
  homepage "https://abseil.io"
  url "https://github.com/abseil/abseil-cpp/archive/refs/tags/20260817.0.tar.gz"
  sha256 "f7e05179df39c45434cad433f5783840bb3788ef322976f9138bc6b72b3a107d"
  license "Apache-2.0"
  compatibility_version 3
  head "https://github.com/abseil/abseil-cpp.git", branch: "master"

  bottle do
    rebuild 1
    sha256               arm64_tahoe:   "ba58c7ded7fbf67a9bcd508055ad1ebd2b3503bf20e0153a92386cc9459d6568"
    sha256               arm64_sequoia: "8a6b64d5f9d44c579343f1ffa7587d08be653c193f5af24579f6ffc1530431ea"
    sha256               arm64_sonoma:  "fa3a183c14d2a9ba7e876bb36d9dbcad6cf3d53b2b2d0a6865e9691fa6920552"
    sha256 cellar: :any, sonoma:        "7dd9d60d2e9ca6c19c97cfb8386f08fd1d5c197564095334e9037bb676c97182"
    sha256 cellar: :any, arm64_linux:   "f1934d2bc3794311e352fdfb12bf067990a7b0c92290155112af27a969b838f7"
    sha256 cellar: :any, x86_64_linux:  "3e6674009eb50e1638f9d2edca486de98a4698ca508b8a26834aaf9d29cc9253"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "googletest" => :build # For test helpers

  deny_network_access!

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
