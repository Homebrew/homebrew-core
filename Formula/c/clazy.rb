class Clazy < Formula
  desc "Qt oriented static code analyzer"
  homepage "https://www.kdab.com/"
  url "https://download.kde.org/stable/clazy/1.17/src/clazy-1.17.tar.xz"
  sha256 "8d7e97a056b1bfbfc730e69855857866729686b8c7e66a22aee81f1baeaab1ec"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/sdk/clazy.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "51018c5113b905459b9c81f91903601b170b5fe335fd3d8ab63474f80388ef9e"
    sha256 cellar: :any,                 arm64_sequoia: "d9fd8c26e803383386d2ee00d7e4b92ea40490d88a2770578ca3a9170db053ad"
    sha256 cellar: :any,                 arm64_sonoma:  "08c5b3ffc58b5f97ca134b1d444600d1fad257be9ca665259530f4c93f82fa84"
    sha256 cellar: :any,                 sonoma:        "cd730358029561b5250b7b7893de72cad9cb5ff0ff9111ceabfe55156637a2a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "611c52be863d8b9d58943b5f90412bf52ebe65accbacf7e989fa0acc356feeaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3449881c3dfe22f07d840adc35c433f362ff73d59298014e9fb0325c4ab2b5fd"
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
