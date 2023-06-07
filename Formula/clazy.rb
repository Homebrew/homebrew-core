class Clazy < Formula
  desc "Qt oriented static code analyzer"
  homepage "https://www.kdab.com/"
  url "https://download.kde.org/stable/clazy/1.11/src/clazy-1.11.tar.xz"
  sha256 "66165df33be8785218720c8947aa9099bae6d06c90b1501953d9f95fdfa0120a"
  license "LGPL-2.0-or-later"
  revision 2
  head "https://invent.kde.org/sdk/clazy.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a716670d3c6a16f67ac39d82813c7fd054761f4d026255f904b10457f67791fb"
    sha256 cellar: :any,                 arm64_monterey: "e5401775aff4f1e6fad0fd459ae01f492c0398101457ffc1d6d0381d4ceb8828"
    sha256 cellar: :any,                 arm64_big_sur:  "d022ef65ffa388d2b6db61b16077dc08a5d5b29185a2723bb631914a4da1fa75"
    sha256 cellar: :any,                 ventura:        "5938ca0a911bb8031870f91b12915eb359eceb0f92f07bc9d5d97996be9bc952"
    sha256 cellar: :any,                 monterey:       "90ef44a60aff61eeb80c8a14ce55954b8d952da25a632c72f255d365c03cfc11"
    sha256 cellar: :any,                 big_sur:        "5237f20d2a267e396777e6afabd0bf7eab77ff174ce05d771aef96d5e5ce62ac"
    sha256 cellar: :any,                 catalina:       "ca761dbfa90f36a5880bf962e68b22d44f8449c5e74083d35dd79ae2d379b4fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f358bdb38ce2bebd90cb2fe9a59dfb8e4a65531a72488f37e0f2473b0ba6bb6c"
  end

  depends_on "cmake"   => [:build, :test]
  depends_on "qt"      => :test
  depends_on "coreutils"
  depends_on "llvm@14"

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  fails_with gcc: "5" # C++17

  def install
    ENV.append "CXXFLAGS", "-std=gnu++17" # Fix `std::regex` support detection.
    system "cmake", "-S", ".", "-B", "build", "-DCLAZY_LINK_CLANG_DYLIB=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
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
    EOS

    (testpath/"test.cpp").write <<~EOS
      #include <QtCore/QString>
      void test()
      {
          qgetenv("Foo").isEmpty();
      }
      int main() { return 0; }
    EOS

    llvm = deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+(\.\d+)*)?$/) }
    ENV["CLANGXX"] = llvm.opt_bin/"clang++"
    system "cmake", "-DCMAKE_CXX_COMPILER=#{bin}/clazy", "."
    assert_match "warning: qgetenv().isEmpty() allocates. Use qEnvironmentVariableIsEmpty() instead",
      shell_output("make VERBOSE=1 2>&1")
  end
end
