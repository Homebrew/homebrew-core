class Abseil < Formula
  desc "C++ Common Libraries"
  homepage "https://abseil.io"
  url "https://github.com/abseil/abseil-cpp/archive/refs/tags/20240722.0.tar.gz"
  sha256 "f50e5ac311a81382da7fa75b97310e4b9006474f9560ac46f54a9967f07d4ae3"
  license "Apache-2.0"
  head "https://github.com/abseil/abseil-cpp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "280f470ee5ae12531a5528850dd90010acb872699064ee273598e4bbc46e304b"
    sha256 cellar: :any,                 arm64_sonoma:   "922c5d7b256fed577b3f7c84ec7a8ce67dddfc7670726e417eaed71bb6878fc6"
    sha256 cellar: :any,                 arm64_ventura:  "0e81f268b9e514694f0dbe17a2cf6fecf1537ed680206e6ef88671345482f7e9"
    sha256 cellar: :any,                 arm64_monterey: "e10b87de708e6731f27a22e3585884749dbcf967a3bd2486ddcae0f410951c3f"
    sha256 cellar: :any,                 sonoma:         "e669331fc89560e725f40f61ad5ef970eeb3f883586f482ac45d45bc21124b82"
    sha256 cellar: :any,                 ventura:        "5d72497268f8335b3955ea9408e33f6235ae1c13dcfb67b14b6a58a0600e4908"
    sha256 cellar: :any,                 monterey:       "68b478c629ee72fd66bca1b4c3944c29e053d9d85315ffc8cd4fe225daefa9a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "847b8ef8ec4bb017c0e43121225b03f742d74d570a560d411db7408d0385e9bd"
  end

  depends_on "cmake" => [:build, :test]

  on_macos do
    depends_on "googletest" => :build # For test helpers
  end

  fails_with gcc: "5" # C++17

  # Fix shell option group handling in pkgconfig files
  # https://github.com/abseil/abseil-cpp/pull/1738
  patch do
    url "https://github.com/abseil/abseil-cpp/commit/9dfde0e30a2ce41077758e9c0bb3ff736d7c4e00.patch?full_index=1"
    sha256 "94a9b4dc980794b3fba0a5e4ae88ef52261240da59a787e35b207102ba4ebfcd"
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
    (testpath/"hello_world.cc").write <<~EOS
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
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.16)

      project(my_project)

      # Abseil requires C++14
      set(CMAKE_CXX_STANDARD 14)

      find_package(absl REQUIRED)

      add_executable(hello_world hello_world.cc)

      # Declare dependency on the absl::strings library
      target_link_libraries(hello_world absl::strings)
    EOS
    system "cmake", testpath
    system "cmake", "--build", testpath, "--target", "hello_world"
    assert_equal "Joined string: foo-bar-baz\n", shell_output("#{testpath}/hello_world")
  end
end
