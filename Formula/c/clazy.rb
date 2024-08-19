class Clazy < Formula
  desc "Qt oriented static code analyzer"
  homepage "https://www.kdab.com/"
  url "https://download.kde.org/stable/clazy/1.12/src/clazy-1.12.tar.xz"
  sha256 "611749141d07ce1e006f8a1253f9b2dbd5b7b44d2d5322d471d62430ec2849ac"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/sdk/clazy.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "d77728a15bb8ce9880ca58de6be9c2d797070005fdc0eced91fc8842919114b9"
    sha256 cellar: :any,                 arm64_ventura:  "f320bb50dd45f262013bb6d6874b13096e5c1f5f7a1527d164e6a76ea0e6590a"
    sha256 cellar: :any,                 arm64_monterey: "6d3d5b87bd999a455c4b3a37af0c1ffd557c730c0c9d8dfe1f0a6dab7e32bb96"
    sha256 cellar: :any,                 sonoma:         "f651d79d2e47ec4e3dd66a33238b4350133a6bdd9d00b20ab5c02ab1055ff831"
    sha256 cellar: :any,                 ventura:        "c088cb0b2ea3c7469aaf6faa065834e1569dc9ab2ee6a051f97f231d82c9499a"
    sha256 cellar: :any,                 monterey:       "34e24dcff3ec435541d3d87928dd74cc7d8dc7ca9f81020e67c9a3dd740fc090"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa742df2bd9d966a119da1e9f82788e4d1e942a43e8c4f8b9da96fa452408388"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "qt" => :test
  depends_on "coreutils"
  depends_on "llvm"

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
