class Freeglut < Formula
  desc "Open-source alternative to the OpenGL Utility Toolkit (GLUT) library"
  homepage "https://freeglut.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/freeglut/freeglut/3.2.1/freeglut-3.2.1.tar.gz"
  sha256 "d4000e02102acaf259998c870e25214739d1f16f67f99cb35e4f46841399da68"
  license "MIT"
  revision 1

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "48bb8108331861a7f4d1ce70472c53ee8a0f4aec75857f1bfc0ab56a59e53787" => :catalina
    sha256 "fdc12ba4122ba3128551768b8abddd4815287a5d5b4ffdc6e00008828c43dd43" => :mojave
    sha256 "c29f4c83e001ee7e6a751769f72b20e5096f30eccf287ca2c572088896e92833" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :test
  depends_on "libx11"
  depends_on "libxi"
  depends_on "libxrandr"
  depends_on "libxxf86vm"
  depends_on "mesa"

  resource "init_error_func.c" do
    url "https://raw.githubusercontent.com/dcnieho/FreeGLUT/c63102d06d09f8a9d4044fd107fbda2034bb30c6/freeglut/freeglut/progs/demos/init_error_func/init_error_func.c"
    sha256 "74ff9c3f722043fc617807f19d3052440073b1cb5308626c1cefd6798a284613"
  end

  def install
    args = %W[
      -DFREEGLUT_BUILD_DEMOS=OFF
      -DOPENGL_INCLUDE_DIR=#{Formula["mesa"].include}
      -DOPENGL_gl_LIBRARY=#{Formula["mesa"].lib}/#{shared_library("libGL")}
    ]
    system "cmake", *std_cmake_args, *args, "."
    system "make", "all"
    system "make", "install"
  end

  test do
    resource("init_error_func.c").stage(testpath)
    flags = shell_output("pkg-config --cflags --libs glut gl xext x11").chomp.split
    system ENV.cc, "init_error_func.c", "-o", "init_error_func", *flags
    assert_match "Entering user defined error handler", shell_output("./init_error_func 2>&1", 1)
  end
end
