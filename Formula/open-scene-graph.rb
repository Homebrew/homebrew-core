class OpenSceneGraph < Formula
  desc "3D graphics toolkit"
  homepage "https://github.com/openscenegraph/OpenSceneGraph"
  url "https://github.com/openscenegraph/OpenSceneGraph/archive/OpenSceneGraph-3.6.5.tar.gz"
  sha256 "aea196550f02974d6d09291c5d83b51ca6a03b3767e234a8c0e21322927d1e12"
  license "LGPL-2.1-or-later" => { with: "WxWindows-exception-3.1" }
  revision 1
  head "https://github.com/openscenegraph/OpenSceneGraph.git", branch: "master"

  bottle do
    sha256 arm64_big_sur: "83350482064d3e55281b5c4a808f4629ce0c243a49fb57e68e5f63d2d5a411c4"
    sha256 big_sur:       "77b57e3edeb952002a4c43c90af2c2ada2813bb35d45b24a07720da89fa389cf"
    sha256 catalina:      "dfa6322ce7e63ce9194a42d3dc1d630572ff7d818ac21e3533017a0bcf5821b6"
    sha256 mojave:        "e347cc9ef89cd9b1e8fea9a6c14a4693f30cd2b43ab4754c61724e229c62849c"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "gtkglext"
  depends_on "jpeg-turbo"
  depends_on "sdl2"

  # patch necessary to ensure support for gtkglext-quartz
  # filed as an issue to the developers https://github.com/openscenegraph/OpenSceneGraph/issues/34
  patch :DATA

  def install
    # Fix "fatal error: 'os/availability.h' file not found" on 10.11 and
    # "error: expected function body after function declarator" on 10.12
    ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version <= :sierra

    args = std_cmake_args + %w[
      -DBUILD_DOCUMENTATION=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_FFmpeg=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_GDAL=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_Jasper=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_OpenEXR=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_SDL=ON
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
