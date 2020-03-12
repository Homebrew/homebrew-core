class Freeglut < Formula
  desc "Open-source alternative to the OpenGL Utility Toolkit (GLUT) library"
  homepage "https://freeglut.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/freeglut/freeglut/3.2.1/freeglut-3.2.1.tar.gz"
  sha256 "d4000e02102acaf259998c870e25214739d1f16f67f99cb35e4f46841399da68"

  bottle do
    cellar :any
    sha256 "48bb8108331861a7f4d1ce70472c53ee8a0f4aec75857f1bfc0ab56a59e53787" => :catalina
    sha256 "fdc12ba4122ba3128551768b8abddd4815287a5d5b4ffdc6e00008828c43dd43" => :mojave
    sha256 "c29f4c83e001ee7e6a751769f72b20e5096f30eccf287ca2c572088896e92833" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on :x11

  patch :DATA

  def install
    inreplace "src/x11/fg_main_x11.c", "CLOCK_MONOTONIC", "UNDEFINED_GIBBERISH" if MacOS.version < :sierra
    system "cmake", *std_cmake_args, "-DFREEGLUT_BUILD_DEMOS=OFF", "."
    system "make", "all"
    system "make", "install"
  end
end

__END__

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 28f8651..d1f6a86 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -258,6 +258,16 @@
 IF(FREEGLUT_GLES)
     LIST(APPEND PUBLIC_DEFINITIONS -DFREEGLUT_GLES)
     LIST(APPEND LIBS GLESv2 GLESv1_CM EGL)
+ELSEIF(APPLE)
+  # on OSX FindOpenGL uses framework version of OpenGL, but we need X11 version
+  FIND_PATH(GLX_INCLUDE_DIR GL/glx.h
+            PATHS /opt/X11/include /usr/X11/include /usr/X11R6/include)
+  FIND_LIBRARY(OPENGL_gl_LIBRARY GL
+               PATHS /opt/X11/lib /usr/X11/lib /usr/X11R6/lib)
+  FIND_LIBRARY(OPENGL_glu_LIBRARY GLU
+               PATHS /opt/X11/lib /usr/X11/lib /usr/X11R6/lib)
+  LIST(APPEND LIBS ${OPENGL_gl_LIBRARY})
+  INCLUDE_DIRECTORIES(${GLX_INCLUDE_DIR})
 ELSE()
   FIND_PACKAGE(OpenGL REQUIRED)
   LIST(APPEND LIBS ${OPENGL_gl_LIBRARY})
