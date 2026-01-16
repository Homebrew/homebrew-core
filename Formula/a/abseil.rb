class Abseil < Formula
  desc "C++ Common Libraries"
  homepage "https://abseil.io"
  url "https://github.com/abseil/abseil-cpp/archive/refs/tags/20260107.0.tar.gz"
  sha256 "4c124408da902be896a2f368042729655709db5e3004ec99f57e3e14439bc1b2"
  license "Apache-2.0"
  head "https://github.com/abseil/abseil-cpp.git", branch: "master"

  bottle do
    sha256                               arm64_tahoe:   "679fc61815e1766f17f00bee96adbd893e67c909847f8c64a50a2b5a8f8a373c"
    sha256                               arm64_sequoia: "34658fda62a841a641422fad4009ccde0e5f87393eb2577a5b083bdbfb54f3c9"
    sha256                               arm64_sonoma:  "aa115570367e0c35003c12e814fd57a88e993471794c37609d348050f10a88d2"
    sha256 cellar: :any,                 sonoma:        "2597c939403696589d7660c1b2f58b1aef3e98cbfe61120f636bda1fbcc5d64b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba6c1c7f40b286832620466ea8f8af959eec4a07fcf25d2720c9f5ce7ac2c986"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "172d809a0f30f2576c8cb520d74810163f68b8bf649955e0a58a8fa140c4070a"
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
