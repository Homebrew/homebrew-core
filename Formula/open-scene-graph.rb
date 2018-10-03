class OpenSceneGraph < Formula
  desc "3D graphics toolkit"
  homepage "https://github.com/openscenegraph/OpenSceneGraph"
  url "https://github.com/openscenegraph/OpenSceneGraph/archive/OpenSceneGraph-3.6.2.tar.gz"
  sha256 "762c6601f32a761c7a0556766097558f453f23b983dd75bcf90f922e2d077a34"
  head "https://github.com/openscenegraph/OpenSceneGraph.git"

  bottle do
    rebuild 1
    sha256 "811df5828f6426af5a8be1087312aad206e854f69799b5458f93043dd8996158" => :mojave
    sha256 "40ecbb33bfc6ff7a08e1f67ff5684d5e8ed53c72d7982fdc8a59e69df938f7cd" => :high_sierra
    sha256 "e2a38c6ff89dad5770b5084f1cd9a8cc2972f7e473a14935dc13eade4e4b2fc3" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "gtkglext"
  depends_on "jpeg"
  depends_on "sdl"

  # patch necessary to ensure support for gtkglext-quartz
  # filed as an issue to the developers https://github.com/openscenegraph/osg/issues/34
  patch :DATA

  def install
    # Fix "fatal error: 'os/availability.h' file not found" on 10.11 and
    # "error: expected function body after function declarator" on 10.12
    if MacOS.version == :sierra || MacOS.version == :el_capitan
      ENV["SDKROOT"] = MacOS.sdk_path
    end

    args = std_cmake_args
    args << "-DBUILD_DOCUMENTATION=ON"
    args << "-DCMAKE_DISABLE_FIND_PACKAGE_FFmpeg=ON"
    args << "-DCMAKE_DISABLE_FIND_PACKAGE_GDAL=ON"
    args << "-DCMAKE_DISABLE_FIND_PACKAGE_TIFF=ON"
    args << "-DCMAKE_DISABLE_FIND_PACKAGE_cairo=ON"
    args << "-DCMAKE_CXX_FLAGS=-Wno-error=narrowing" # or: -Wno-c++11-narrowing
    args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.arch_64_bit}"
    args << "-DOSG_DEFAULT_IMAGE_PLUGIN_FOR_OSX=imageio"
    args << "-DOSG_WINDOWING_SYSTEM=Cocoa"

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "doc_openscenegraph"
      system "make", "install"
      doc.install Dir["#{prefix}/doc/OpenSceneGraphReferenceDocs/*"]
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <osg/Version>
      using namespace std;
      int main()
        {
          cout << osgGetVersion() << endl;
          return 0;
        }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-losg", "-o", "test"
    assert_equal `./test`.chomp, version.to_s
  end
end
__END__
diff --git a/CMakeModules/FindGtkGl.cmake b/CMakeModules/FindGtkGl.cmake
index 321cede..6497589 100644
--- a/CMakeModules/FindGtkGl.cmake
+++ b/CMakeModules/FindGtkGl.cmake
@@ -10,7 +10,7 @@ IF(PKG_CONFIG_FOUND)
     IF(WIN32)
         PKG_CHECK_MODULES(GTKGL gtkglext-win32-1.0)
     ELSE()
-        PKG_CHECK_MODULES(GTKGL gtkglext-x11-1.0)
+        PKG_CHECK_MODULES(GTKGL gtkglext-quartz-1.0)
     ENDIF()

 ENDIF()
