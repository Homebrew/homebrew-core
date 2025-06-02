class Clazy < Formula
  desc "Qt oriented static code analyzer"
  homepage "https://www.kdab.com/"
  url "https://download.kde.org/stable/clazy/1.14/src/clazy-1.14.tar.xz"
  sha256 "993f786dac668c29c4f357cb95c8a6ddca555ebbb94854efb9b570f683ad4d43"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/sdk/clazy.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f77da44dd6c29e34637aa0d1ffe5bd4c208a769191592e7e883e2640788b4276"
    sha256 cellar: :any,                 arm64_sonoma:  "d0f0990494babab458cbc91cee206598fbe98e303761c49e43a8924fe9f4fff0"
    sha256 cellar: :any,                 arm64_ventura: "9cbecaf7b22a02e178294518a281bfbf87be09a2de877144a6b273759f4e32ca"
    sha256 cellar: :any,                 sonoma:        "2a822345e7ca596102229fe92e6352e1595749ad1ac3a5822f647b18b70d027c"
    sha256 cellar: :any,                 ventura:       "8dd499299e6a778461782447004253825cea74c4702858946ae986c1ff120ffa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c73a9e02fd2c35ad10d89ca686830fef3e25af2b0aa2d0fdde508eb69217454e"
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
