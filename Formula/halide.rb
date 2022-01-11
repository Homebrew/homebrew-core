class Halide < Formula
  desc "Language for fast, portable data-parallel computation"
  homepage "https://halide-lang.org"
  url "https://github.com/halide/Halide/archive/v13.0.3.tar.gz"
  sha256 "864f74b9ee6dc41f123ee497ce30cb296e668fa5c8da2eaf39c42320a55ad731"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d1c01c49367e212ea55a4afddff9d3635c3280e46b3574adcd3f3392f580fc86"
    sha256 cellar: :any,                 arm64_big_sur:  "c70099d8f8d0523473b58d99c86b15333a89d36835d95ae6768a599728d6f46d"
    sha256 cellar: :any,                 monterey:       "b9bd3c8c31e28c6ec24efba058f0fa7d41c8e5887f4321ffc8beca5842469d4b"
    sha256 cellar: :any,                 big_sur:        "a6d4cdeba4f0f38b9f7cee427058afcf5f7de6e561908a88e743a49cced1c7f9"
    sha256 cellar: :any,                 catalina:       "a602ab499b3a036f701c3e2c916b520a97e12888141e62cd7be060e01caeb763"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1f20a8dab5a3dcd2ec5aac608833856c1abffe77e76e3d352b7528a19b6dbed"
  end

  depends_on "cmake" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "llvm"
  depends_on "python@3.10"

  fails_with gcc: "5" # LLVM is built with Homebrew GCC

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DHalide_SHARED_LLVM=ON"
      system "make"
      system "make", "install"
    end
  end

  test do
    cp share/"doc/Halide/tutorial/lesson_01_basics.cpp", testpath
    system ENV.cxx, "-std=c++17", "lesson_01_basics.cpp", "-L#{lib}", "-lHalide", "-o", "test"
    assert_match "Success!", shell_output("./test")
  end
end
