class Clazy < Formula
  desc "Qt oriented static code analyzer"
  homepage "https://www.kdab.com/"
  url "https://invent.kde.org/sdk/clazy/-/archive/v1.17.1/clazy-v1.17.1.tar.gz"
  sha256 "d67a930833cdfef446a3db2e3c39a966876f09358bca31cd1e67aace0773bc31"
  license "LGPL-2.0-or-later"
  revision 1
  head "https://invent.kde.org/sdk/clazy.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f3d9ef37f0224e47b5e492a25ac5e6faa3e282d2be0e1461b56f2bbcb6e0b8e1"
    sha256 cellar: :any, arm64_tahoe:       "46af170a343811fffddffcefe5c7ea9f707e492ea941b1930ed8af8279097b62"
    sha256 cellar: :any, arm64_sequoia:     "d5f535a71c9eadc7d802252083ed385e1d66666643e3d2989f04017ade4b9eb4"
    sha256 cellar: :any, arm64_sonoma:      "64294b544080267532bd792cb93d30c7f82c93ea1512b0fe8fc8b6568571f490"
    sha256 cellar: :any, sonoma:            "a0dbf1e7c3864f9b5a79396b0f1f4557182196a9d36ec24f7989e31fe761494c"
    sha256 cellar: :any, arm64_linux:       "2b257f16bff6c57d28b0c4b53b98f32c8db0118dd4e9f086214cc41c44253f22"
    sha256 cellar: :any, x86_64_linux:      "c4b5077a10c143b6a0de0a778c5ed56da7aec40fbd9be472ba2a0dbea3eaa8bd"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "qtbase" => :test
  depends_on "llvm"

  on_macos do
    depends_on "coreutils" # for greadlink
  end

  fails_with :clang do
    cause "errors while linking LLVM's static libraries due to libLTO version"
  end

  def install
    # macOS has undefined symbols if only linking clang-cpp.
    # This is just the default value already set by CMakeLists.txt.
    args = ["-DCLAZY_LINK_CLANG_DYLIB=#{OS.mac? ? "OFF" : "ON"}"]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION #{Formula["cmake"].version})

      project(test VERSION 1.0.0 LANGUAGES CXX)

      set(CMAKE_CXX_STANDARD 17)
      set(CMAKE_CXX_STANDARD_REQUIRED ON)

      set(CMAKE_AUTOMOC ON)
      set(CMAKE_AUTORCC ON)
      set(CMAKE_AUTOUIC ON)

      find_package(Qt6 COMPONENTS Core REQUIRED)
      add_executable(test test.cpp)
      target_link_libraries(test PRIVATE Qt6::Core)
    CMAKE

    (testpath/"test.cpp").write <<~CPP
      #include <QtCore/QString>
      void test()
      {
          qgetenv("Foo").isEmpty();
      }
      int main() { return 0; }
    CPP

    llvm = deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+(\.\d+)*)?$/) }
    ENV["CLANGXX"] = llvm.opt_bin/"clang++"
    system "cmake", "-DCMAKE_CXX_COMPILER=#{bin}/clazy", "."
    assert_match "warning: qgetenv().isEmpty() allocates. Use qEnvironmentVariableIsEmpty() instead",
      shell_output("make VERBOSE=1 2>&1")
  end
end
