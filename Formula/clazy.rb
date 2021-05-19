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
    sha256 cellar: :any, arm64_big_sur: "9ab24ea5bf0d8e16e2bc565ed2950b9bde9037dc364fff0103d04130f1c30696"
    sha256 cellar: :any, big_sur:       "2c052548e31701dcb7afbcb8b44c152bb13c0a11f37beab616cf81d54d456a30"
    sha256 cellar: :any, catalina:      "8208e32b87a292ea3e3e738a87c7e9e7336e05dd805767b580fe50fe931e6fe5"
    sha256 cellar: :any, mojave:        "9a0b81ad2009c80e07ee96c21c44dadae440923c0256e103f7c24b4941195cbd"
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
