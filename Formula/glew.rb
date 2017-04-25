class Glew < Formula
  desc "OpenGL Extension Wrangler Library"
  homepage "https://glew.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/glew/glew/2.0.0/glew-2.0.0.tgz"
  sha256 "c572c30a4e64689c342ba1624130ac98936d7af90c3103f9ce12b8a0c5736764"
  head "https://github.com/nigels-com/glew.git"

  bottle do
    cellar :any
    sha256 "6d1af9d3f60da8c423fb1723c631abd784335b81cd8cda606fb0d30240dbae3a" => :sierra
    sha256 "200ab3d519d234bf9a34b223faa07c1ace46eeda197b9352e1b6dc0a67846b4b" => :el_capitan
    sha256 "6f2809e99ea25d6d33280921b5cd50e148800228450c34043d8ce11ac8f7e32c" => :yosemite
    sha256 "2b72bd7d59343ae64eaa87fd69f806759ac356a77300bb6b6a6ab40247384dc2" => :mavericks
  end

  option "with-cmake", "Build GLEW with CMake"

  depends_on "cmake" => [:build, :optional] if build.with? "cmake"

  patch :DATA

  def install
    inreplace "glew.pc.in", "Requires: @requireslib@", ""

    if build.with? "cmake"
      cd "build" do
        system "cmake", "./cmake", *std_cmake_args
        system "make"
        system "make", "install"
      end
    else
      system "make", "GLEW_PREFIX=#{prefix}", "GLEW_DEST=#{prefix}", "all"
      system "make", "GLEW_PREFIX=#{prefix}", "GLEW_DEST=#{prefix}", "install.all"
    end

    doc.install Dir["doc/*"]
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <GL/glew.h>
      #include <GLUT/glut.h>

      int main(int argc, char** argv) {
        glutInit(&argc, argv);
        glutCreateWindow("GLEW Test");
        GLenum err = glewInit();
        if (GLEW_OK != err) {
          return 1;
        }
        return 0;
      }
    EOS
    system ENV.cc, testpath/"test.c", "-o", "test", "-L#{lib}", "-lGLEW",
           "-framework", "GLUT"
    system "./test"
  end
end

__END__

diff --git a/build/cmake/CMakeLists.txt b/build/cmake/CMakeLists.txt
index 8077929..34e8e06 100644
--- a/build/cmake/CMakeLists.txt
+++ b/build/cmake/CMakeLists.txt
@@ -93,7 +93,9 @@ if (WIN32)
 endif ()

 add_library (glew SHARED ${GLEW_PUBLIC_HEADERS_FILES} ${GLEW_SRC_FILES})
-set_target_properties (glew PROPERTIES COMPILE_DEFINITIONS "GLEW_BUILD" OUTPUT_NAME "${GLEW_LIB_NAME}" PREFIX "${DLL_PREFIX}")
+set_target_properties (glew PROPERTIES COMPILE_DEFINITIONS "GLEW_BUILD" OUTPUT_NAME "${GLEW_LIB_NAME}" PREFIX "${DLL_PREFIX}"
+                                       VERSION ${GLEW_VERSION}
+                                       SOVERSION ${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR})
 add_library (glew_s STATIC ${GLEW_PUBLIC_HEADERS_FILES} ${GLEW_SRC_FILES})
 set_target_properties (glew_s PROPERTIES COMPILE_DEFINITIONS "GLEW_STATIC" OUTPUT_NAME "${GLEW_LIB_NAME}" PREFIX lib)
