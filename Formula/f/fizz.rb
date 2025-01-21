class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2024.12.02.00/fizz-v2024.12.02.00.tar.gz"
  sha256 "4d6fc99f65a53f9fdff5751bfe822da89cb792c7898b63583ef9f034ae41d64c"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8bb5b3a6edeee6ab808b7122457c58ada41f459152303d3a10082dde167b081b"
    sha256 cellar: :any,                 arm64_sonoma:  "6c3b5fc9d99ad2cd4ff3473b4fc5ce62e744c93709ad5abadb01f7a683ea2684"
    sha256 cellar: :any,                 arm64_ventura: "ecf069b557a6ef996d0321b3a7526cb2992fa809a39792ffbe1655d8d5e57b98"
    sha256 cellar: :any,                 sonoma:        "8310099784a83b395cf5cc65aec343d48288ee0221fed4b51fed2ddb3a2e49b5"
    sha256 cellar: :any,                 ventura:       "9a1a0cf6777ddea9bb1f5ab02c21f5aea9c666c6107358ff0b92faaefb23ce3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f67932d4f086898517bdc0eafe06cf0a64259f5a5070b5e4447480a407a27634"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "libevent" => :build
  depends_on "double-conversion"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libsodium"
  depends_on "openssl@3"
  depends_on "zstd"

  uses_from_macos "zlib"

  # fix ambiguous reference to gflags, upstream pr ref, https://github.com/facebookincubator/fizz/pull/153
  patch do
    url "https://github.com/facebookincubator/fizz/commit/ebd194681cc2ee7669d2dea2b802ae473f3d03d2.patch?full_index=1"
    sha256 "3dfb5453678b5fad48b99fef2555b9c4b2535c5099fe3c32929c4f1c0b531f6f"
  end

  def install
    args = ["-DBUILD_TESTS=OFF", "-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
    if OS.mac?
      # Prevent indirect linkage with boost and snappy.
      args += [
        "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-dead_strip_dylibs",
        "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs",
      ]
    end
    system "cmake", "-S", "fizz", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # `libsodium` does not install a CMake package configuration file. There
    # is a find module (at least in 1.0.20 tarball), but upstream has deleted
    # it in HEAD. Also, find modules are usually not shipped by upstream[^1].
    #
    # Since fizz-config.cmake requires FindSodium.cmake[^2], we save a copy in
    # libexec that can be used internally for testing `fizz` and dependents.
    #
    # [^1]: https://cmake.org/cmake/help/latest/manual/cmake-packages.7.html#find-module-packages
    # [^2]: https://github.com/facebookincubator/fizz/issues/141
    (libexec/"cmake").install "build/fbcode_builder/CMake/FindSodium.cmake"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <fizz/client/AsyncFizzClient.h>
      #include <iostream>

      int main() {
        auto context = fizz::client::FizzClientContext();
        std::cout << toString(context.getSupportedVersions()[0]) << std::endl;
      }
    CPP

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.5)
      project(test LANGUAGES CXX)
      set(CMAKE_CXX_STANDARD 17)

      list(APPEND CMAKE_MODULE_PATH "#{libexec}/cmake")
      find_package(gflags REQUIRED)
      find_package(fizz CONFIG REQUIRED)

      add_executable(test test.cpp)
      target_link_libraries(test fizz::fizz)
    CMAKE

    ENV.delete "CPATH"

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    assert_match "TLS", shell_output("./build/test")
  end
end
