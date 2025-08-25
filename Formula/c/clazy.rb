class Clazy < Formula
  desc "Qt oriented static code analyzer"
  homepage "https://www.kdab.com/"
  url "https://download.kde.org/stable/clazy/1.15/src/clazy-1.15.tar.xz"
  sha256 "43189460b366ea3126242878c36ee8a403e37ec4baef7e61ccfa124b1414e7a9"
  license "LGPL-2.0-or-later"
  revision 1
  head "https://invent.kde.org/sdk/clazy.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "8e82a24432fe70dbdc57d15a6e000f9965862570357db03f6fa7f24b8b179b9b"
    sha256 cellar: :any,                 arm64_sonoma:  "e9615987f29c4795cbe367210445d23ac6288a9162f2b14fa16011cf92ca3342"
    sha256 cellar: :any,                 arm64_ventura: "71125eaff0f77b0ff435fb1a994743c557fb39c411297437f765ddeddf1b8a7b"
    sha256 cellar: :any,                 sonoma:        "3f5a1d5289b111d1c313034902c77bb56373fac7d4eb93dea8a55c691496c3e4"
    sha256 cellar: :any,                 ventura:       "1a901cc6580997ddcd7f6d4f5f963c73875edc2dca0b911939b824ccb98731a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10e829a29aa7e265e7e1f482a86cef69cb3a45190326475390f00b323af5217b"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "qt" => :test
  depends_on "coreutils"
  depends_on "llvm"

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
