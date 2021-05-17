class Clazy < Formula
  desc "Qt oriented static code analyzer"
  homepage "https://www.kdab.com/"
  url "https://download.kde.org/stable/clazy/1.9/src/clazy-1.9.tar.xz"
  sha256 "4c6c2e473e6aa011cc5fab120ebcffec3fc11a9cc677e21ad8c3ea676eb076f8"
  license "LGPL-2.0-or-later"
  revision 1
  head "https://invent.kde.org/sdk/clazy.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "d2f5bcff669119459a6c4ea01a4e640ac936d78930ffd19a76e37ad7e3a7056a"
    sha256 cellar: :any, big_sur:       "d5e6536a502e26bdf722dfb33a09c01934054848b8424aac51dc23f9bf405fd8"
    sha256 cellar: :any, catalina:      "e67252da7ff4a6811b672ff43920b757330c7ed7bf45d754db416c9044fad90e"
    sha256 cellar: :any, mojave:        "1b2d26176223e0a1ec8cc1f1f4c2b823cb93823aed94858c68ee47fa93cc269f"
  end

  depends_on "cmake"   => [:build, :test]
  depends_on "llvm@11" => [:build, :test]
  depends_on "qt"      => :test

  depends_on "coreutils"

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    # avoid use llvm libc++
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm@11"].opt_lib
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
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

    ENV["CLANGXX"] = Formula["llvm@11"].opt_bin/"clang++"
    system "cmake", "-DCMAKE_CXX_COMPILER=#{bin}/clazy", "."
    assert_match "warning: qgetenv().isEmpty() allocates. Use qEnvironmentVariableIsEmpty() instead",
      shell_output("make VERBOSE=1 2>&1")
  end
end
