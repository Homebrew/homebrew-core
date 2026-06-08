class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/archive/refs/tags/v2026.06.01.00.tar.gz"
  sha256 "c59640372e10c687c5ddd362f79ea47e24827bb5b491de75a1969e827f7b06d7"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4d7aa53a8dcf3496dab90d4903468e24050efff1bd7f7b8eaec0805793d59382"
    sha256 cellar: :any, arm64_sequoia: "b1a1576e28005c0b51094a72a7c2cb2cdaffadd4425bda97d7ba592f1b57f23a"
    sha256 cellar: :any, arm64_sonoma:  "01cf3d4a7d41264ffbbc1a83445ac4c2063a1f175e79b6ed81d2e6839e79ae2a"
    sha256 cellar: :any, sonoma:        "f85fcd25a05bf6c0948eafd16c093e6843cc0f682572d4101837f90072148034"
    sha256 cellar: :any, arm64_linux:   "0ba80d21362bd09c55c4d73e50b45018ace0c8217e0676e9ef8728d9763171f1"
    sha256 cellar: :any, x86_64_linux:  "a9d9fb6cd0ce82ad2e238aa87cc0185a80975bb71cbd5acffd19aa167a8a74ce"
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
