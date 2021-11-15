class Clazy < Formula
  desc "Qt oriented static code analyzer"
  homepage "https://www.kdab.com/"
  url "https://download.kde.org/stable/clazy/1.10/src/clazy-1.10.tar.xz"
  sha256 "4ce6d55ffcddacdb005d847e0c329ade88a01e8e4f7590ffd2a9da367c1ba39d"
  license "LGPL-2.0-or-later"
  revision 1
  head "https://invent.kde.org/sdk/clazy.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "c44b906300b19fd0f3fa64dd98c6edf58065a59494d040e7d1121944fd36df2e"
    sha256 cellar: :any, arm64_big_sur:  "7d15f90dbe42c90a9920c117854b94f17908622df7def7d4d5dda8b5303ef7e5"
    sha256 cellar: :any, monterey:       "a325c3349a7bbcde4d330a19b030a2d54c57ddfd222e66022825ca04cd9d2123"
    sha256 cellar: :any, big_sur:        "a873bc99b80959e45cf74c388bdefd9541a985f87e42de9b35a6ad82bec5953f"
    sha256 cellar: :any, catalina:       "57301f79bae291ae0817b4b6577f49a4ea2136849d36b8c0b949c026995ebb2a"
    sha256 cellar: :any, mojave:         "6c2cf6029ba58ad5d7fa13098fcd18d9514315bc57e11c090f351f4e93df5350"
  end

  depends_on "cmake"   => [:build, :test]
  depends_on "qt"      => :test
  depends_on "coreutils"
  depends_on "llvm"

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

    ENV["CLANGXX"] = Formula["llvm"].opt_bin/"clang++"
    system "cmake", "-DCMAKE_CXX_COMPILER=#{bin}/clazy", "."
    assert_match "warning: qgetenv().isEmpty() allocates. Use qEnvironmentVariableIsEmpty() instead",
      shell_output("make VERBOSE=1 2>&1")
  end
end
