class Abseil < Formula
  desc "C++ Common Libraries"
  homepage "https://abseil.io"
  license "Apache-2.0"
  revision 1
  head "https://github.com/abseil/abseil-cpp.git", branch: "master"

  stable do
    url "https://github.com/abseil/abseil-cpp/archive/refs/tags/20250814.0.tar.gz"
    sha256 "9b2b72d4e8367c0b843fa2bcfa2b08debbe3cee34f7aaa27de55a6cbb3e843db"

    # Backport fix for older GCC
    patch do
      url "https://github.com/abseil/abseil-cpp/commit/ba9a180d22e62edcd5f6c56b50287b286f96fc33.patch?full_index=1"
      sha256 "f0403bf23edf3ac67365c645d81602d5bd965890a1db5a797794aca5b4b6ebb3"
    end
  end

  bottle do
    sha256                               arm64_tahoe:   "e7671a6aa73bde7610deaa7e8576e1fbb84a491c763842cfd375ee8f2d0d6dcd"
    sha256                               arm64_sequoia: "3f77da27a9016e6ed26abbaeff2b95b486dab89875e9a019eb4ea8c37a89219a"
    sha256                               arm64_sonoma:  "3214ab769d0ea60c4ae6fa81fe752b242b737d2a75bf1610736185f3996fe9f2"
    sha256 cellar: :any,                 sonoma:        "880f97986104b646e3e4a86a6adad49c0655c85164a298f2f97db048d466e752"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ceca21bf67e428b999e68f1c2a2c16e7f45963e6b9fe1b41c866cc81d30bf29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9a6b46c0444c8a87d68d36a8b0f2921a98ac1e3bdac3f1579ab9207d9f03ad4"
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
