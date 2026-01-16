class Pegtl < Formula
  desc "Parsing Expression Grammar Template Library"
  homepage "https://github.com/taocpp/PEGTL"
  url "https://github.com/taocpp/PEGTL/archive/refs/tags/3.2.8.tar.gz"
  sha256 "319e8238daebc3a163f60c88c78922a8012772076fdd64a8dafaf5619cd64773"
  # license got changed to BSL-1.0 in main per https://github.com/taocpp/PEGTL/commit/c7630f1649906daf08b8ddca1420e66b542bae2b
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4cc6917959a4a5589e44b04a3f60a2c6be767b2d5ef302af832b62804af8a342"
  end

  depends_on "cmake" => :build

  def install
    args = %w[
      -DPEGTL_BUILD_TESTS=OFF
      -DPEGTL_BUILD_EXAMPLES=OFF
      -DCMAKE_CXX_STANDARD=17
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    rm "src/example/pegtl/CMakeLists.txt"
    (pkgshare/"examples").install (buildpath/"src/example/pegtl").children
  end

  test do
    system ENV.cxx, pkgshare/"examples/hello_world.cpp", "-std=c++17", "-o", "helloworld"
    assert_equal "Good bye, homebrew!\n", shell_output("./helloworld 'Hello, homebrew!'")
  end
end
