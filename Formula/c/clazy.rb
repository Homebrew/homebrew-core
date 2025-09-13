class Clazy < Formula
  desc "Qt oriented static code analyzer"
  homepage "https://www.kdab.com/"
  url "https://download.kde.org/stable/clazy/1.16/src/clazy-v1.16.tar.xz"
  sha256 "0fa9e9ce54969edfb2c831815b724be9ab89c41ac3a40c0033c558173c4c302b"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/sdk/clazy.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "92b3ccdbef548d7966861ace46c31f90af6e8c0c641f68f1a0768fa817c5f862"
    sha256 cellar: :any,                 arm64_sonoma:  "33da10d4e320a5730af1514d6e00ac84bc8d354b8a6d69a4e2578aa9524b7473"
    sha256 cellar: :any,                 arm64_ventura: "f6af64aef4696d355d87c6def7d18b3cc7cd6d36a5a2932bccecc3d893371d99"
    sha256 cellar: :any,                 sonoma:        "cf75552ce773a8e7b822c4b2f7c6bbbaef2b1977ed6715c022de3769fb0ff906"
    sha256 cellar: :any,                 ventura:       "5152cbc2134bfcb219b9e0c95ec62500910cd775248a8168db30fe09057b8ddc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ec42d9e2bb8e000491b657536396520554521bc03cf1d6f41638af98b007e20"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "qt" => :test
  depends_on "coreutils"
  depends_on "llvm"

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
