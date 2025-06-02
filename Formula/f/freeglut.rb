class Freeglut < Formula
  desc "Open-source alternative to the OpenGL Utility Toolkit (GLUT) library"
  homepage "https://freeglut.sourceforge.net/"
  url "https://github.com/freeglut/freeglut/releases/download/v3.6.0/freeglut-3.6.0.tar.gz"
  sha256 "9c3d4d6516fbfa0280edc93c77698fb7303e443c1aaaf37d269e3288a6c3ea52"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "15142599aa482cf0cd446ae930ea18cc39d0244ac980254ab1f97b135000e1af"
    sha256 cellar: :any,                 arm64_sonoma:   "cbd441a4a55c8b7db3732964e1dea5709fc7a9698a3bfc8df498f306a19b7df9"
    sha256 cellar: :any,                 arm64_ventura:  "9e1d3f9c8cedb8b611e66158e898d46bbcb4e28aaf5280536917b0f30b207cb7"
    sha256 cellar: :any,                 arm64_monterey: "02606145d1a13b1a22e9ce8b61c61701dd903b17aa962f9abbdfe558cc3e00ca"
    sha256 cellar: :any,                 sonoma:         "ae8ac9e040e9fdefa287e882cd7fec7b0952a98dc5bf025875b0b16d2c6a37a6"
    sha256 cellar: :any,                 ventura:        "e636688689f5be4828151ce0ad415387fd10b0a6fd4610a9c0919882c8e084c9"
    sha256 cellar: :any,                 monterey:       "95b2565476d715ae6a7a8230ae2af1539455cdba8b898e640ef1f7ca2e7926a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "3405d3188375a12576a2c5a4fb747b2699b5cc8c771222a1d94cc0067d0edff9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2dd41f7adaac60fd1674cd3147c0f10d6eb37f48345b1b13d6f080c4d0e1a68b"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test
  depends_on "libx11"
  depends_on "libxi"
  depends_on "libxrandr"
  depends_on "libxxf86vm"
  depends_on "mesa"

  on_linux do
    depends_on "mesa-glu"
    depends_on "xinput"
  end

  resource "init_error_func.c" do
    url "https://raw.githubusercontent.com/dcnieho/FreeGLUT/c63102d06d09f8a9d4044fd107fbda2034bb30c6/freeglut/freeglut/progs/demos/init_error_func/init_error_func.c"
    sha256 "74ff9c3f722043fc617807f19d3052440073b1cb5308626c1cefd6798a284613"
  end

  def install
    # Can remove cmake policy minimum in next release
    # https://github.com/freeglut/freeglut/commit/2294389397912c9a6505a88221abb7dca0a4fb79
    args = %W[
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
      -DFREEGLUT_BUILD_DEMOS=OFF
      -DOPENGL_INCLUDE_DIR=#{Formula["mesa"].include}
      -DOPENGL_gl_LIBRARY=#{Formula["mesa"].lib/shared_library("libGL")}
    ]
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource("init_error_func.c").stage(testpath)
    flags = shell_output("pkgconf --cflags --libs glut gl xext x11").chomp.split
    system ENV.cc, "init_error_func.c", "-o", "init_error_func", *flags
    assert_match "Entering user defined error handler", shell_output("./init_error_func 2>&1", 1)
  end
end
