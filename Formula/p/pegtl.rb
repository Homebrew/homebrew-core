class Pegtl < Formula
  desc "Parsing Expression Grammar Template Library"
  homepage "https://github.com/taocpp/PEGTL"
  url "https://github.com/taocpp/PEGTL/archive/refs/tags/4.0.0.tar.gz"
  sha256 "6181ea42478e0aba84512be59595476adac781881b5e372224ed9b730994bd8e"
  license "BSL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fe5eedfeae61697749bf8476edc4106a79acb7ad6e1f31237ab6fbc006db094f"
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

    rm "src/example/CMakeLists.txt"
    (pkgshare/"examples").install (buildpath/"src/example").children
  end

  test do
    system ENV.cxx, pkgshare/"examples/hello_world.cpp", "-std=c++17", "-o", "helloworld"
    assert_equal "Good bye, homebrew!\n", shell_output("./helloworld 'Hello, homebrew!'")
  end
end
