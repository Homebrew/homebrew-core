class Freeglut < Formula
  desc "Open-source alternative to the OpenGL Utility Toolkit (GLUT) library"
  homepage "https://freeglut.sourceforge.net/"
  url "https://github.com/freeglut/freeglut/releases/download/v3.8.0/freeglut-3.8.0.tar.gz"
  sha256 "674dcaff25010e09e450aec458b8870d9e98c46f99538db457ab659b321d9989"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "0f211e5010be3c1e5d5b9eb61f574558fba876456385cc822db183cf67c8c3c6"
    sha256 cellar: :any, arm64_sequoia: "b83d33f198634143226f771055570cf99ca9893eade73ff1ec798bd953c55a60"
    sha256 cellar: :any, arm64_sonoma:  "8200a7568a87e1720ebb1ef191c01480ecf69e1d1a43b339d1818473a42f527e"
    sha256 cellar: :any, sonoma:        "c1f7f6578f454da32643c188b0dfc5bae7bdab0c18cf8de2fd1ab4ffb581b442"
    sha256 cellar: :any, arm64_linux:   "3bde6f2895079e01081744ae5ba7df996a7e3718f16a8d7dfcb75324e802b938"
    sha256 cellar: :any, x86_64_linux:  "902ba4a099c5e9cbaf5c36ce2e5112f97603390dd02b8d05eff72e5f0b75ffe2"
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
  end

  resource "init_error_func.c" do
    url "https://raw.githubusercontent.com/dcnieho/FreeGLUT/c63102d06d09f8a9d4044fd107fbda2034bb30c6/freeglut/freeglut/progs/demos/init_error_func/init_error_func.c"
    sha256 "74ff9c3f722043fc617807f19d3052440073b1cb5308626c1cefd6798a284613"
  end

  def install
    args = %W[
      -DFREEGLUT_BUILD_DEMOS=OFF
      -DOPENGL_INCLUDE_DIR=#{Formula["mesa"].include}
      -DOPENGL_gl_LIBRARY=#{Formula["mesa"].lib/shared_library("libGL")}
    ]
    # Prevent CMake from discarding RPATH to mesa.
    # TODO: Should drop this when we introduce `libglvnd`
    args << "-DCMAKE_INSTALL_RPATH=#{formula_opt_lib("mesa")}" if OS.linux?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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
