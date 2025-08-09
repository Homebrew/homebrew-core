class Abseil < Formula
  desc "C++ Common Libraries"
  homepage "https://abseil.io"
  url "https://github.com/abseil/abseil-cpp/archive/refs/tags/20250512.1.tar.gz"
  sha256 "9b7a064305e9fd94d124ffa6cc358592eb42b5da588fb4e07d09254aa40086db"
  license "Apache-2.0"
  head "https://github.com/abseil/abseil-cpp.git", branch: "master"

  bottle do
    sha256                               arm64_sequoia: "88d505cd2d8e56fba67e8d6b65633c5e1880dde280f8c20b35170e1e65fcc07a"
    sha256                               arm64_sonoma:  "42482c23f6a8636e271708a8e9fd39a9bebfb76f4527ee9c520ceb1b01d2e6c0"
    sha256                               arm64_ventura: "0e63620f980c6b13de71fa5fe4f7b6f1a73aa784c1242df71b83a0c498376a6b"
    sha256 cellar: :any,                 sonoma:        "fa19056852c4ca43f4dc2d72e93986789b87b0aedbe67f54712f4419421f2f84"
    sha256 cellar: :any,                 ventura:       "768b2978a5aa694ff11b9de3c7134a09fc3c2360b94a0455ecfd2e8f5649647f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52cc4b7a46930c18ce86454427bd38b66037dec02e57ac7faeaf40e5e2866e19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0a26b8a1cd3c3ba42273b5a6549a247cec6b82493c28d344ff11197b06c33b2"
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
