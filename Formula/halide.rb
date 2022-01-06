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
    sha256 cellar: :any, arm64_monterey: "ea3a63da5483882027b23374cf1baa7e052491b12a9cabeef8032b0f54060349"
    sha256 cellar: :any, arm64_big_sur:  "b05a77c5550d6d7aad127cf1ba8d5d2d3e7cea7f3eedade51928fa5ecc140b51"
    sha256 cellar: :any, monterey:       "dd301f63d9055dbd9f66b145de35de4c1f748452e7f619db5752b9a9a44c338c"
    sha256 cellar: :any, big_sur:        "63f98a4ff2d1ed7c857c035471e8a81dac356b6276c158e3618b68e30b16b1c6"
    sha256 cellar: :any, catalina:       "774a638ce8052a05907926a176992435d44eb0eaf251893b3bd2ee049a230a0a"
  end

  depends_on "cmake" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "llvm"
  depends_on "python@3.10"

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
