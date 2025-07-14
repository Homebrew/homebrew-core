class Clazy < Formula
  desc "Qt oriented static code analyzer"
  homepage "https://www.kdab.com/"
  url "https://download.kde.org/stable/clazy/1.15/src/clazy-1.15.tar.xz"
  sha256 "43189460b366ea3126242878c36ee8a403e37ec4baef7e61ccfa124b1414e7a9"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/sdk/clazy.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "03d60e08e418660c7286774c37b3bd17b730ddda664361fe419c82162b66c1e7"
    sha256 cellar: :any,                 arm64_sonoma:  "9d2d6f1982fc14742465c4987b402c8e691d60f84de7fe7dd86e10e7549019d1"
    sha256 cellar: :any,                 arm64_ventura: "cd2063fd4fe49132e6c30ee4c0ac300bb1a6241524207f9a88627ed91f18351b"
    sha256 cellar: :any,                 sonoma:        "23bd208dc64c9845af740359e2f6872d7c2e00a577fda9f33bab3c9b268cfc53"
    sha256 cellar: :any,                 ventura:       "f2b30c57b2197c7bce742653499cc63f655809deb8debc231db200b2569f900b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c88959211e64d00f133d5bfa4f4889c63a04aebc646f5d6fc8301677c6c8abfc"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "qt" => :test
  depends_on "coreutils"
  depends_on "llvm@19" # LLVM 20 issue: https://invent.kde.org/sdk/clazy/-/issues/27

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCLAZY_LINK_CLANG_DYLIB=ON", *std_cmake_args
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

      add_executable(test
          test.cpp
      )

      target_link_libraries(test PRIVATE Qt6::Core
      )
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
