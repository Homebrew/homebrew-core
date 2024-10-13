class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2024.10.07.00/fizz-v2024.10.07.00.tar.gz"
  sha256 "c5b19ee2c72c358a619eb274d372015bd49a9bc2de6a8501f86dc6324edab825"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5c246ac14ac596e3d4d0178afaf63012266a326eece5097ea647373dda59443c"
    sha256 cellar: :any,                 arm64_sonoma:  "c104d443aafe4f9fb8ff5608066a43b2e6fa863a4ba5d36b717fea24d0c9f8c2"
    sha256 cellar: :any,                 arm64_ventura: "58b8c654a628866628b112f54100eaf91c199aa2b4a938aafc757b28aeb92738"
    sha256 cellar: :any,                 sonoma:        "c34fbd3bac28a82b2b9d9feff64f1ab647efa3493a5932f25adb305e2cb464aa"
    sha256 cellar: :any,                 ventura:       "5afda80b4b6667f6314714557f52fd594c9a2b39e30fae7450e98e632572612f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3098d4fc16c6a99d613487ad31d5f3160afae895f71cb843c62d734277777699"
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

  fails_with gcc: "5"

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
    (testpath/"test.cpp").write <<~EOS
      #include <fizz/client/AsyncFizzClient.h>
      #include <iostream>

      int main() {
        auto context = fizz::client::FizzClientContext();
        std::cout << toString(context.getSupportedVersions()[0]) << std::endl;
      }
    EOS

    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.5)
      project(test LANGUAGES CXX)
      set(CMAKE_CXX_STANDARD 17)

      list(APPEND CMAKE_MODULE_PATH "#{libexec}/cmake")
      find_package(gflags REQUIRED)
      find_package(fizz CONFIG REQUIRED)

      add_executable(test test.cpp)
      target_link_libraries(test fizz::fizz)
    EOS

    ENV.delete "CPATH"
    system "cmake", ".", *std_cmake_args
    system "cmake", "--build", "."
    assert_match "TLS", shell_output("./test")
  end
end
