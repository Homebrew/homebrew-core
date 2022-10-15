class Freeglut < Formula
  desc "Open-source alternative to the OpenGL Utility Toolkit (GLUT) library"
  homepage "https://freeglut.sourceforge.io/"
  url "https://github.com/FreeGLUTProject/freeglut/releases/download/v3.4.0/freeglut-3.4.0.tar.gz"
  sha256 "3c0bcb915d9b180a97edaebd011b7a1de54583a838644dcd42bb0ea0c6f3eaec"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "85f94ee7f0436554c19f3e8f50fda475bdf913c04fec8e23792056adc1e1fb79"
    sha256 cellar: :any,                 arm64_big_sur:  "b2cbc54b86715fbf75f671e11165d1a2b61ae5185d5d5e73c6fefe1fb36ccd5a"
    sha256 cellar: :any,                 monterey:       "b4bb0d39e2a2d9d67298665b11cdd28e2e66ab58e6d35ffc2a9f7a3962574273"
    sha256 cellar: :any,                 big_sur:        "1a218709c3f10ddf43df97c79ee616d7ad9aa5f5c8c10f44060266e3ae641b42"
    sha256 cellar: :any,                 catalina:       "74a7a0bf713cb2030d4eb0f9d6d234bec221c97d5113ba36b1ebb71df6257d52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "057c5a28a73b5c225322f4c8fd878f80b632e22e13f294a733e2ce1c9b7c4149"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :test
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
