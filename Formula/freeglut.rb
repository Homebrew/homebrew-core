class Freeglut < Formula
  desc "Open-source alternative to the OpenGL Utility Toolkit (GLUT) library"
  homepage "https://freeglut.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/freeglut/freeglut/3.2.1/freeglut-3.2.1.tar.gz"
  sha256 "d4000e02102acaf259998c870e25214739d1f16f67f99cb35e4f46841399da68"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b2ba809784fa9d9aa7364b8a9bfa7604f03db29ee33b8f471327cf676e26a6a9"
    sha256 cellar: :any,                 arm64_big_sur:  "203bade82803af2a0b0fae9e3049ed61d9a4e1f4f6efd42fc6160c7296a54f2e"
    sha256 cellar: :any,                 monterey:       "3e7c1021010984328014280c1e734e69fbcd7b41882c9c8e3697d827be972b90"
    sha256 cellar: :any,                 big_sur:        "078bc333780fea9d4dd745529c91326a3ea4bcd393c18a0d817fd7870d90b7a2"
    sha256 cellar: :any,                 catalina:       "21e92d3aa8a1615937c6776292dd823912220d272a4a437f66917d1e6dd0b655"
    sha256 cellar: :any,                 mojave:         "8d71afe59334afe060d513d68e8c76b3fc0927cf05d61b146dd1444c66d5db35"
    sha256 cellar: :any,                 high_sierra:    "0a30955c90e594481f1ebf4dd218065768386704e2fdcdc0aae45055171dfd2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b6950bd59195ef3256e524f3b78fcc01f0a79c8f43f83346b285154b773d4b9"
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
