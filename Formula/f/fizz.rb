class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/archive/refs/tags/v2026.07.20.00.tar.gz"
  sha256 "5001a5273cc6dce59e9dfb19cb8787ec0768982ab1ee073642543458de9b753e"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c03f88d7b55165ce27e79063a592836fd5630bde192ad5d2cfa4b4e247bb253c"
    sha256 cellar: :any, arm64_sequoia: "edaf0aef573daa69ffd37d0070a65d706ad7c6c4a34c78773f4348382a59b5e1"
    sha256 cellar: :any, arm64_sonoma:  "3de452724887ff80722b6e6f008f23271544adfa7172c421dedb54330cf5d208"
    sha256 cellar: :any, sonoma:        "13d899cfd52d02f4ae55859db92e9ff273c67f3bac89f6ccb0fbc3ac80e03846"
    sha256 cellar: :any, arm64_linux:   "f2c23c00ea388e901d0aaccdb91de7ac3b0229893b15bb24c3363577cb56ef18"
    sha256 cellar: :any, x86_64_linux:  "81cb5135f9c13ac280c516fa0110ebdbc820656c33fc75746fa1f5db74fd45f0"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "gflags" => :build
  depends_on "libevent" => :build
  depends_on "fmt"
  depends_on "folly"
  depends_on "glog"
  depends_on "libsodium"
  depends_on "openssl@3"
  depends_on "zstd"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = %W[
      -DBUILD_EXAMPLES=OFF
      -DBUILD_TESTS=OFF
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    if OS.mac?
      # Prevent indirect linkage with boost and snappy.
      args += %w[
        -DCMAKE_EXE_LINKER_FLAGS=-Wl,-dead_strip_dylibs
        -DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs
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
      cmake_minimum_required(VERSION 4.0)
      project(test LANGUAGES CXX)
      set(CMAKE_CXX_STANDARD 20)

      list(APPEND CMAKE_MODULE_PATH "#{libexec}/cmake")
      find_package(gflags REQUIRED)
      find_package(fizz CONFIG REQUIRED)

      add_executable(test test.cpp)
      target_link_libraries(test fizz::fizz)
    CMAKE

    ENV.delete "CPATH"

    args = OS.mac? ? [] : ["-DCMAKE_BUILD_RPATH=#{lib};#{HOMEBREW_PREFIX}/lib"]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    assert_match "TLS", shell_output("./build/test")
  end
end
