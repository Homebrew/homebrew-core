class Clazy < Formula
  desc "Qt oriented static code analyzer"
  homepage "https://www.kdab.com/"
  url "https://download.kde.org/stable/clazy/1.12/src/clazy-1.12.tar.xz"
  sha256 "611749141d07ce1e006f8a1253f9b2dbd5b7b44d2d5322d471d62430ec2849ac"
  license "LGPL-2.0-or-later"
  revision 1
  head "https://invent.kde.org/sdk/clazy.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4c414da467a6431fa3fcb801a9782193e4bc33c79e5c46ce89225d59ad89f0cd"
    sha256 cellar: :any,                 arm64_sonoma:  "de510c93eac7168ae31e41ddf5c016a143ca82cfd303155dc00869ea58a777d6"
    sha256 cellar: :any,                 arm64_ventura: "48c9b07863a47b5d5e53a97ccaf6e1ae5dfa19c9ee484a800cf342fd43b9967f"
    sha256 cellar: :any,                 sonoma:        "c1ea2d9d4092095114db97f32bb67c008c865e0724366724305d13272d495e5b"
    sha256 cellar: :any,                 ventura:       "2795771a1d25fd000c81613aedf48ffaf9a394fa30e2e4ff140d83b85e69076f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60afe9ee7a03dbee90248110fd343c0c3a4be1192e86050562d76ff0add050d4"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "qt" => :test
  depends_on "coreutils"
  depends_on "llvm@18"

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  fails_with gcc: "5" # C++17

  def install
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
