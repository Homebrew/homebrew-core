class Abseil < Formula
  desc "C++ Common Libraries"
  homepage "https://abseil.io"
  url "https://github.com/abseil/abseil-cpp/archive/refs/tags/20250814.1.tar.gz"
  sha256 "1692f77d1739bacf3f94337188b78583cf09bab7e420d2dc6c5605a4f86785a1"
  license "Apache-2.0"
  head "https://github.com/abseil/abseil-cpp.git", branch: "master"

  bottle do
    sha256                               arm64_tahoe:   "a420c5f258edbae66fd2f5ac17320d46fd1e9e884f1cbb7cb23c9711e46d67f8"
    sha256                               arm64_sequoia: "fc8915867a2ee9678dc1603c12d4b69e4c88fc5e5e4d71b44b1279e7a598bcc1"
    sha256                               arm64_sonoma:  "327300ffe635b76ee159dafd5cdc48f5a6ff9757673673b75d8a86ed6ca08475"
    sha256 cellar: :any,                 sonoma:        "15a4561cad35249b0f19cb876e874e4a8d892e287267985c24a47cb6835ec66d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd2d71f5e2f747eda4d887d3d841ae87f6d1e02d337ae635f54c1444daacc6bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f1d2a133d4f0273361ac12b4b9286ce855a53914dbdd2d85b095efe779f62a1"
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
