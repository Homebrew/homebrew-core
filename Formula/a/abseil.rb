class Abseil < Formula
  desc "C++ Common Libraries"
  homepage "https://abseil.io"
  url "https://github.com/abseil/abseil-cpp/archive/refs/tags/20240722.1.tar.gz"
  sha256 "40cee67604060a7c8794d931538cb55f4d444073e556980c88b6c49bb9b19bb7"
  license "Apache-2.0"
  head "https://github.com/abseil/abseil-cpp.git", branch: "master"

  bottle do
    rebuild 1
    sha256                               arm64_sequoia: "7e5a0a8ef391c005cb154d461e76ee997ad0d3c0176f09757d85027c01a14392"
    sha256                               arm64_sonoma:  "77fe46423b43ca37df6acc3867c4c1206b2afd28ff511aab7a3d70515ce70856"
    sha256                               arm64_ventura: "bdcb35636c6cd1c570a15a15dedf77e2e671945d55e28fcba50e2c62bf67a410"
    sha256 cellar: :any,                 sonoma:        "f59d69e8c777caaa48de0e78bd35d7437c3848be3c85952684075bfb6df10312"
    sha256 cellar: :any,                 ventura:       "a534872a681524cd15c94713f9f2fa3ee48d71e585cdb1cb7b11c677607c62b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "700f81a3eb4942d1f8e87feabb6cbb5655d07fcc86efea65e514cc9d2865eb47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ffaa8c163b9b3ee6de502d076c148e0f64395f4d30e3eccbb0bb4d6f3c44400"
  end

  depends_on "cmake" => [:build, :test]

  on_macos do
    depends_on "googletest" => :build # For test helpers
  end

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
