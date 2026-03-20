class Clazy < Formula
  desc "Qt oriented static code analyzer"
  homepage "https://www.kdab.com/"
  url "https://download.kde.org/stable/clazy/1.17/src/clazy-1.17.tar.xz"
  sha256 "8d7e97a056b1bfbfc730e69855857866729686b8c7e66a22aee81f1baeaab1ec"
  license "LGPL-2.0-or-later"
  revision 1
  head "https://invent.kde.org/sdk/clazy.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5bcb2600e1302c815509fc3e454cca551fb47dfa51a28db508f24bd695c1de59"
    sha256 cellar: :any,                 arm64_sequoia: "221da1944debc0c0d614aeee305556abce3bad5ccddd6c2bee6b48aa394a45ce"
    sha256 cellar: :any,                 arm64_sonoma:  "de271713dc02508e7ae1ae7275123ea71c7c250a94e4b6b65df6b361d067ba11"
    sha256 cellar: :any,                 sonoma:        "941b9d823264678dca2c87ec94dd8411d176e04e33fec83b14ddbad604f81f86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "696507d8a2bfe111ad00e871b55c77113c3527b27d529ef781a98915b5971bc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a5b96d9b276dd91bab3efb833365892be64a8101888f528375b980178561f8e"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "qtbase" => :test
  depends_on "llvm"

  on_macos do
    depends_on "coreutils" # for greadlink
  end

  fails_with :clang do
    cause "errors while linking LLVM's static libraries due to libLTO version"
  end

  def install
    # macOS has undefined symbols if only linking clang-cpp.
    # This is just the default value already set by CMakeLists.txt.
    args = ["-DCLAZY_LINK_CLANG_DYLIB=#{OS.mac? ? "OFF" : "ON"}"]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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
      add_executable(test test.cpp)
      target_link_libraries(test PRIVATE Qt6::Core)
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
