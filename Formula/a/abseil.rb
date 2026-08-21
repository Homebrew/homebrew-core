class Abseil < Formula
  desc "C++ Common Libraries"
  homepage "https://abseil.io"
  url "https://github.com/abseil/abseil-cpp/archive/refs/tags/20260817.0.tar.gz"
  sha256 "f7e05179df39c45434cad433f5783840bb3788ef322976f9138bc6b72b3a107d"
  license "Apache-2.0"
  compatibility_version 3
  head "https://github.com/abseil/abseil-cpp.git", branch: "master"

  bottle do
    sha256               arm64_tahoe:   "aa7710934e670efceb986c58f54d731366f0c6cd3b81612891eb8ab1d1ac69df"
    sha256               arm64_sequoia: "e6ae7c910a942457ffd322b5260c9b060c3f7b00e972161f88f5af609e730cba"
    sha256               arm64_sonoma:  "1e3a0986f1b75cb12f5300f94464b25e86e408228e266d9856fced7bc9e8c8a9"
    sha256 cellar: :any, sonoma:        "6d98d8c3f909cb8a02e9a13bf1a0cc38a514333a3cb23c04d187cfe3d968444c"
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
