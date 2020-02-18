class OpenSceneGraph < Formula
  desc "3D graphics toolkit"
  homepage "https://github.com/openscenegraph/OpenSceneGraph"
  url "https://github.com/openscenegraph/OpenSceneGraph/archive/OpenSceneGraph-3.6.5.tar.gz"
  sha256 "aea196550f02974d6d09291c5d83b51ca6a03b3767e234a8c0e21322927d1e12"
  head "https://github.com/openscenegraph/OpenSceneGraph.git"

  bottle do
    sha256 "37cc7954c600e2fe0f65f572b688de6baaf412a7953cf3c53960fa3033a849a1" => :catalina
    sha256 "9eb6303b01ad351b61d80b93e2448065820592042954dfa13bc8177943863b6c" => :mojave
    sha256 "fb185cfd6505823c2f6fd7c4832c16eec1ae075a9173a24ff5c21aebb86bd537" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "gtkglext"
  depends_on "jpeg-turbo"
  depends_on "sdl"

  # patch necessary to ensure support for gtkglext-quartz
  # filed as an issue to the developers https://github.com/openscenegraph/OpenSceneGraph/issues/34
  patch :DATA

  def install
    # Fix "fatal error: 'os/availability.h' file not found" on 10.11 and
    # "error: expected function body after function declarator" on 10.12
    if MacOS.version == :sierra || MacOS.version == :el_capitan
      ENV["SDKROOT"] = MacOS.sdk_path
    end

    args = std_cmake_args + %w[
      -DBUILD_DOCUMENTATION=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_FFmpeg=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_GDAL=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_Jasper=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_OpenEXR=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_TIFF=ON
      -DCMAKE_CXX_FLAGS=-Wno-error=narrowing
      -DCMAKE_OSX_ARCHITECTURES=x86_64
      -DOSG_DEFAULT_IMAGE_PLUGIN_FOR_OSX=imageio
      -DOSG_WINDOWING_SYSTEM=Cocoa
    ]

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
