class Abseil < Formula
  desc "C++ Common Libraries"
  homepage "https://abseil.io"
  url "https://github.com/abseil/abseil-cpp/archive/refs/tags/20250127.1.tar.gz"
  sha256 "b396401fd29e2e679cace77867481d388c807671dc2acc602a0259eeb79b7811"
  license "Apache-2.0"
  head "https://github.com/abseil/abseil-cpp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "be7b3373c56a0e1ee2c0c2e85ee4d17e2105ac1d9d6d63011da28d636fec7424"
    sha256 cellar: :any,                 arm64_sonoma:  "595c40777cd92592402192786840521dc52fd5fdf45696faafb1147e30faa70a"
    sha256 cellar: :any,                 arm64_ventura: "ab5bb6d11867d0aa667462da453032971ce38ce880c4922cd879adda2de37bda"
    sha256 cellar: :any,                 sonoma:        "6e47e3012f074e9248dd0dcea675108c13cb7f2e5a179cec7ae53a9e4fbbcd15"
    sha256 cellar: :any,                 ventura:       "cccbbd0ba628e1207d30ec33a24f93a3326b01770c5187725a90602c6ce97f34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de8a488dfc0e7b19dd651de54b5646731d80141120c3c29267d1402e65a50ade"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17fc2037e8cc64c28b77e0a03546ac1c80ae7cc6fd6748386d60cd61e117cca2"
  end

  depends_on "cmake" => [:build, :test]

  on_macos do
    depends_on "googletest" => :build # For test helpers
  end

  def install
    ENV.runtime_cpu_detection

    # Install test helpers. Doing this on Linux requires rebuilding `googltest` with `-fPIC`.
    extra_cmake_args = if OS.mac?
      %w[ABSL_BUILD_TEST_HELPERS ABSL_USE_EXTERNAL_GOOGLETEST ABSL_FIND_GOOGLETEST].map do |arg|
        "-D#{arg}=ON"
      end
    end.to_a

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
