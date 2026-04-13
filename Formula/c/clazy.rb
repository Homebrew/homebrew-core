class Clazy < Formula
  desc "Qt oriented static code analyzer"
  homepage "https://www.kdab.com/"
  url "https://invent.kde.org/sdk/clazy/-/archive/v1.17.1/clazy-v1.17.1.tar.gz"
  sha256 "d67a930833cdfef446a3db2e3c39a966876f09358bca31cd1e67aace0773bc31"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/sdk/clazy.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "53ab754b46351e9ec36adfa911ea40766080d3fbc031ec9c193713f49dc412ef"
    sha256 cellar: :any,                 arm64_sequoia: "ae9d29e616d555914c8e64b1f511eeb27288b9295b47ea3dec5fb8165dfb6b54"
    sha256 cellar: :any,                 arm64_sonoma:  "25798fd7832c37ee667f990d09c92efc1af628ed3a81f7258083639daa3063e3"
    sha256 cellar: :any,                 sonoma:        "8f1450d3bc4d9ce5ef3b89e076bcc301ed215bb6631ad32e5b9be0c2926371af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6cd0dbf3f2a3e853f7859710e8908e36b87657a956d113c9bb809ec550bc18a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0cfd169bb2e3bd13585cbbe46c65d3375638164f10e0d924eaf51bc46698412"
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
