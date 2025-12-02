class Freeglut < Formula
  desc "Open-source alternative to the OpenGL Utility Toolkit (GLUT) library"
  homepage "https://freeglut.sourceforge.net/"
  url "https://github.com/freeglut/freeglut/releases/download/v3.8.0/freeglut-3.8.0.tar.gz"
  sha256 "674dcaff25010e09e450aec458b8870d9e98c46f99538db457ab659b321d9989"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c702ef020f0ee587f8a6c583bd91f0e0ae905aae875b19c9ce91a30918b04c77"
    sha256 cellar: :any,                 arm64_sequoia: "4c326ac55184f3e15dd828ac8f3c39a3f132aaca816a7429492a3a8a7a9e4dc0"
    sha256 cellar: :any,                 arm64_sonoma:  "7428dbf49dcc32e79623cbf4653640b5e847062f6cd0f0522a893e698734a2fe"
    sha256 cellar: :any,                 sonoma:        "271aaea7bbd3cce73d950c7dfbe2f68d1246e2dc35d3efd7e1e111f921aa870d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4028f390685ccdbc27d63e8a13b13ac04eeb38d59ea713a02e0e4cd957cd87e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1a792596562e423cfc3c800166b2347d12b805a70395339bfe175752474d354"
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
    args = %W[
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
