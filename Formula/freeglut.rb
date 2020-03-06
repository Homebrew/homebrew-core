class Freeglut < Formula
  desc "Open-source alternative to the OpenGL Utility Toolkit (GLUT) library"
  homepage "https://freeglut.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/freeglut/freeglut/3.2.1/freeglut-3.2.1.tar.gz"
  sha256 "d4000e02102acaf259998c870e25214739d1f16f67f99cb35e4f46841399da68"

  bottle do
    cellar :any
    sha256 "76e54ff5c4dce5cbe729e1a4c39c5a2049329197b61ebf04d2987489eac262d9" => :catalina
    sha256 "5d701c190fea27fad91532d1e66164d6ebeb4f406dc91291986b841c4fe169ef" => :mojave
    sha256 "587bdcd98c006a1077dbb077a36439c67b14064c9430c610225971f0b1b549ad" => :high_sierra
    sha256 "ac029acfd40b4c4381dc241e1e0ad94f950cd05ed7c76348e5550a3f848d0152" => :sierra
    sha256 "e3f9e0796917b54055f737677324560db1ffd849c415a1a40019598383671139" => :el_capitan
    sha256 "c2816abf98614e8bf4fc1e6fb65a10d637bf1b85659cf7e9e524bee4d46b3ebe" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on :x11

  patch :DATA

  def install
    inreplace "src/x11/fg_main_x11.c", "CLOCK_MONOTONIC", "UNDEFINED_GIBBERISH" if MacOS.version < :sierra
    system "cmake", "-DFREEGLUT_BUILD_DEMOS=OFF", "-DCMAKE_INSTALL_PREFIX=#{prefix}", "."
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
