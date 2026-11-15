class Pegtl < Formula
  desc "Parsing Expression Grammar Template Library"
  homepage "https://github.com/taocpp/PEGTL"
  url "https://github.com/taocpp/PEGTL/archive/refs/tags/4.0.2.tar.gz"
  sha256 "0fe55b672cbeaa4dc047b7658f0a5d6aae0d94a5ee25727d25df43f148fc8709"
  license "BSL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3442a0ffb5d5d3f892347f7dc7f2fd940b191ab6026210c021f43be5a76bf4d2"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    args = %w[
      -DPEGTL_BUILD_TESTS=OFF
      -DPEGTL_BUILD_EXAMPLES=OFF
      -DCMAKE_CXX_STANDARD=17
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    rm "src/example/CMakeLists.txt"
    (pkgshare/"examples").install (buildpath/"src/example").children
  end

  test do
    system ENV.cxx, pkgshare/"examples/hello_world.cpp", "-std=c++17", "-o", "helloworld"
    assert_equal "Good bye, homebrew!\n", shell_output("./helloworld 'Hello, homebrew!'")
  end
end
