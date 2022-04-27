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
    sha256 cellar: :any,                 arm64_monterey: "fad1df33efebf700d5329eddce6ad261c667e8e4b73b0a27d8a0db33e31ffd28"
    sha256 cellar: :any,                 arm64_big_sur:  "79ef1923f1d400cdb819e2b981e6fd6cb9632c16cce36de504e985f723ff3138"
    sha256 cellar: :any,                 monterey:       "0f460acc6eff9ab586f4bc43b41247147fad62bc1dc4e59c6aec738f8f70c737"
    sha256 cellar: :any,                 big_sur:        "e5534a8dca79cc95ea78e7a45f496187eb731f109be790df6bf1974334eb8475"
    sha256 cellar: :any,                 catalina:       "f8829bbea066fec01afe36746ef08a4f35e021ad699bdb5c1aac6b8edd1ccb29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "449e65447d16635d47941364ea2ddd274e314893774e798becfb24e232f82ca5"
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
