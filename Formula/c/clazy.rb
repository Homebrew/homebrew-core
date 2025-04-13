class Clazy < Formula
  desc "Qt oriented static code analyzer"
  homepage "https://www.kdab.com/"
  url "https://download.kde.org/stable/clazy/1.13/src/clazy-1.13.tar.xz"
  sha256 "6d36da0c9d4d2f8602fb52910bde34bf27501ff758f6182b1a46fa0a91779ef4"
  license "LGPL-2.0-or-later"
  revision 1
  head "https://invent.kde.org/sdk/clazy.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "38da1abaafefe00b8d566a6ecb8aa619834fe325ee4654bba2779ac7e005ec51"
    sha256 cellar: :any,                 arm64_sonoma:  "481169d2ceba0ae69862e5fac8a6d318feb24989625fb0d2c91212aa420df8f1"
    sha256 cellar: :any,                 arm64_ventura: "cf1e847bbb0429c4eb955cba0957218823d3b9df9fd3946ef807dc10cd23a467"
    sha256 cellar: :any,                 sonoma:        "c28c640557ca631975f091153815b15de679819a785c4582c3a5b391bf9f5cfb"
    sha256 cellar: :any,                 ventura:       "9d26d49ad1194c82c0383f54ec778b88b9747babd74e25cd683b8b44893ac87b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db982fe89ed2ecb712d65dbb9c5ffe7bbbd21fbb1f9115c8afcbaec48036f3c1"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "qt" => :test
  depends_on "coreutils"
  depends_on "llvm@19" # LLVM 20 issue: https://invent.kde.org/sdk/clazy/-/issues/27

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
