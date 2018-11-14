class OpenSceneGraph < Formula
  desc "3D graphics toolkit"
  homepage "https://github.com/openscenegraph/OpenSceneGraph"
  url "https://github.com/openscenegraph/OpenSceneGraph/archive/OpenSceneGraph-3.6.3.tar.gz"
  sha256 "51bbc79aa73ca602cd1518e4e25bd71d41a10abd296e18093a8acfebd3c62696"
  head "https://github.com/openscenegraph/OpenSceneGraph.git"

  bottle do
    sha256 "153c47045ba21b94581aed7375218a38534077fc8920090dc541627d09ef36c5" => :mojave
    sha256 "adabb1b668bdfec8e6ccc1e05a91577bbe0c58487d345b662c3acaae2298e8a9" => :high_sierra
    sha256 "8f69c72133ca7100385f49d104f33517c66aefe7c76bb22e08b28c8aaa4c6385" => :sierra
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
