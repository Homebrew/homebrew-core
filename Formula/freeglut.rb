class Freeglut < Formula
  desc "Open-source alternative to the OpenGL Utility Toolkit (GLUT) library"
  homepage "https://freeglut.sourceforge.io/"
  url "https://github.com/FreeGLUTProject/freeglut/releases/download/v3.4.0/freeglut-3.4.0.tar.gz"
  sha256 "3c0bcb915d9b180a97edaebd011b7a1de54583a838644dcd42bb0ea0c6f3eaec"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ee111ddfa7bdc0a6b3e6857e900d387388264bc5b0c6334d8c5e103b762fec8b"
    sha256 cellar: :any,                 arm64_monterey: "149209f3f7f7f2d849bfd938ca7da2abe9e1302f41fa1bb107985087c97aa9cc"
    sha256 cellar: :any,                 arm64_big_sur:  "232cbfd50de1285bbc009e713da698c25d9928b42de042f001a74ef5f83e990f"
    sha256 cellar: :any,                 ventura:        "7c7e7fe57e38c1f1bdcd52a4ec9e81a217699131bb88ce35f8865963179d288a"
    sha256 cellar: :any,                 monterey:       "dcebb4520aba3f89fb3662e5d896ac1eef92fd57259e94402d53b2d12ad66a19"
    sha256 cellar: :any,                 big_sur:        "16825f785a572f580450f63be3c51fd737303ee664b4c774eaea7b7dcf434db3"
    sha256 cellar: :any,                 catalina:       "ebd335220912ca9e72e40d98358f6e8d6f0d27c4c72024ac1d6a59004301cba6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7751750942757f330249bf3d6a84c7a6b69fe4a29cbb502832c338ccd1927d7"
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
