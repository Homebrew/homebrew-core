class Clazy < Formula
  desc "Qt oriented static code analyzer"
  homepage "https://www.kdab.com/"
  url "https://download.kde.org/stable/clazy/1.11/src/clazy-1.11.tar.xz"
  sha256 "66165df33be8785218720c8947aa9099bae6d06c90b1501953d9f95fdfa0120a"
  license "LGPL-2.0-or-later"
  revision 1
  head "https://invent.kde.org/sdk/clazy.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "aaaa160995aa8134003713a92fa61ccf94a2ef918b5f20cd01e646e12537f57a"
    sha256 cellar: :any,                 arm64_big_sur:  "9fbf9d700955ad17fa061447e4d4665781c4e7110f0c7214e5944710f927ce7e"
    sha256 cellar: :any,                 monterey:       "a96fce75ba8454e0fea0b4c7925e9f3c64ecd4f6332ffdc4ddc7a9fcd7c16e2b"
    sha256 cellar: :any,                 big_sur:        "d0130eecf3cffb4ecb14168f7fad810c7f11264bfd9163d67f7bdd8d2dd11aee"
    sha256 cellar: :any,                 catalina:       "b4e73e0bdaf4fd050513f2697b11bac66c8bf4d24ba6a33ec116b3447d296639"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fdc8926cc35d4ca571c707289b6051055e625bb829b57765b880df0e84a18ff"
  end

  depends_on "cmake"   => [:build, :test]
  depends_on "qt"      => :test
  depends_on "coreutils"
  depends_on "llvm"

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5" # C++17

  def install
    ENV.append "CXXFLAGS", "-std=gnu++17" # Fix `std::regex` support detection.
    system "cmake", "-S", ".", "-B", "build", "-DCLAZY_LINK_CLANG_DYLIB=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    gcc_version = Formula["gcc"].version.major unless OS.mac?

    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION #{Formula["cmake"].version})

      project(test VERSION 1.0.0 LANGUAGES CXX)

      set(CMAKE_CXX_STANDARD 17)
      set(CMAKE_CXX_STANDARD_REQUIRED ON)

      if (UNIX AND NOT APPLE)
        include_directories(#{Formula["gcc"].opt_include}/c++/#{gcc_version})
        include_directories(#{Formula["gcc"].opt_include}/c++/#{gcc_version}/x86_64-pc-linux-gnu)
        link_directories(#{Formula["gcc"].opt_lib}/gcc/#{gcc_version})
      endif()

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

    ENV["CLANGXX"] = Formula["llvm"].opt_bin/"clang++"
    system "cmake", "-DCMAKE_CXX_COMPILER=#{bin}/clazy", "."
    assert_match "warning: qgetenv().isEmpty() allocates. Use qEnvironmentVariableIsEmpty() instead",
      shell_output("make VERBOSE=1 2>&1")
  end
end
