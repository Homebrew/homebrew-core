class Clazy < Formula
  desc "Qt oriented static code analyzer"
  homepage "https://www.kdab.com/"
  url "https://download.kde.org/stable/clazy/1.9/src/clazy-1.9.tar.xz"
  sha256 "4c6c2e473e6aa011cc5fab120ebcffec3fc11a9cc677e21ad8c3ea676eb076f8"
  license "LGPL-2.0-or-later"
  revision 2
  head "https://invent.kde.org/sdk/clazy.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "a8ddb146d2b1a6058a8a86772e24b6f4bcbb76d9ff254557a4bbc4bd152acb0e"
    sha256 cellar: :any, big_sur:       "c81f75e0c903da26f703002ecc1377a0b393ed7cfe5803c6351fadf6c131318d"
    sha256 cellar: :any, catalina:      "d0f860fc174f54e0b0022a995f556fe7aa4f2cb3ed016863d4fe970e57112c57"
    sha256 cellar: :any, mojave:        "7d16a3e2c951be1d7bc818a12efb4e8af98050e846d367fd9e505c10a556c72b"
  end

  depends_on "cmake"   => [:build, :test]
  depends_on "qt"      => :test
  depends_on "coreutils"
  depends_on "llvm@11"

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
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
