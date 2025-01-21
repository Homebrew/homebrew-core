class Clazy < Formula
  desc "Qt oriented static code analyzer"
  homepage "https://www.kdab.com/"
  url "https://download.kde.org/stable/clazy/1.13/src/clazy-1.13.tar.xz"
  sha256 "6d36da0c9d4d2f8602fb52910bde34bf27501ff758f6182b1a46fa0a91779ef4"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/sdk/clazy.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "befed9e3e396380d703605d0c951c3906ec5132eaa00e7331913521d168b0683"
    sha256 cellar: :any,                 arm64_sonoma:  "17c7fddf8588b5eb3036e694e47e0bacb9e1cc4c72cb7e41df27ac7549a8e07b"
    sha256 cellar: :any,                 arm64_ventura: "2857ba1a5e9e7d03d342acecbce06ad1bc0d9ca74df84960529ae28205f9887b"
    sha256 cellar: :any,                 sonoma:        "bb07ed1692e2565c9b0c4ee901b0249b335141e8292d3882dd9fc19d54e59cb6"
    sha256 cellar: :any,                 ventura:       "83f55f60617d1be46cf987cd6c90d8456372fc76a113b497645eafc709d35910"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82caf7f18cc0624a9772df4c8d4cf219cbb10dc1b46ac040d19dd555bd8876be"
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
