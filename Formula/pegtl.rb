class Pegtl < Formula
  desc "Parsing Expression Grammar Template Library"
  homepage "https://github.com/taocpp/PEGTL"
  url "https://github.com/taocpp/PEGTL/archive/3.0.0.tar.gz"
  sha256 "b47af025450f5c12251cd831f90deab666e18a8029f3dbffb32672b0450af902"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "abf71571ff392323eb08f1cadb23d744900467cbcb26a9a8f2e689e8af93b6be" => :big_sur
    sha256 "10ad60dbc5a6c4054579b2e7529dfb053395cfd2c9bc5ddb5c2bf6b939b8f9cd" => :catalina
    sha256 "10ad60dbc5a6c4054579b2e7529dfb053395cfd2c9bc5ddb5c2bf6b939b8f9cd" => :mojave
    sha256 "10ad60dbc5a6c4054579b2e7529dfb053395cfd2c9bc5ddb5c2bf6b939b8f9cd" => :high_sierra
  end

  depends_on "cmake" => :build

  if MacOS.version <= :mojave
    depends_on "gcc"
    fails_with :clang do
      cause "'path' is unavailable in c++ < 17: introduced in macOS 10.15"
    end
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                            "-DPEGTL_BUILD_TESTS=OFF",
                            "-DPEGTL_BUILD_EXAMPLES=OFF",
                            "-DCMAKE_CXX_STANDARD=17"
      system "make", "install"
    end
    rm "src/example/pegtl/CMakeLists.txt"
    (pkgshare/"examples").install (buildpath/"src/example/pegtl").children
  end

  test do
    system ENV.cxx, pkgshare/"examples/hello_world.cpp", "-std=c++17", "-o", "helloworld"
    assert_equal "Good bye, homebrew!\n", shell_output("./helloworld 'Hello, homebrew!'")
  end
end
