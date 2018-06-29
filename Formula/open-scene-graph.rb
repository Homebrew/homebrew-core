class OpenSceneGraph < Formula
  desc "3D graphics toolkit"
  homepage "https://github.com/openscenegraph/OpenSceneGraph"
  url "https://github.com/openscenegraph/OpenSceneGraph/archive/OpenSceneGraph-3.6.2.tar.gz"
  sha256 "762c6601f32a761c7a0556766097558f453f23b983dd75bcf90f922e2d077a34"
  head "https://github.com/openscenegraph/OpenSceneGraph.git"

  bottle do
    sha256 "6d119978e6b0be8fbf3b360a839daa16b3a817f273e30d51b1412c23e7c322cc" => :high_sierra
    sha256 "c9e5fa017123bb06bf1c4c23397928e7de5b83cc943059c59ee9d5359d86b4d8" => :sierra
    sha256 "20f1be2cd539d632d23dc8b9a29af0e2d619aac6346ce7d3c6b46525424140d8" => :el_capitan
  end

  option "with-docs", "Build the documentation with Doxygen and Graphviz"

  deprecated_option "docs" => "with-docs"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "gtkglext"
  depends_on "freetype"
  depends_on "sdl"
  depends_on "gdal" => :optional
  depends_on "jasper" => :optional
  depends_on "openexr" => :optional
  depends_on "dcmtk" => :optional
  depends_on "librsvg" => :optional
  depends_on "collada-dom" => :optional
  depends_on "gnuplot" => :optional
  depends_on "ffmpeg" => :optional

  # patch necessary to ensure support for gtkglext-quartz
  # filed as an issue to the developers https://github.com/openscenegraph/osg/issues/34
  patch :DATA

  if build.with? "docs"
    depends_on "doxygen" => :build
    depends_on "graphviz" => :build
  end

  def install
    # Fix "fatal error: 'os/availability.h' file not found" on 10.11 and
    # "error: expected function body after function declarator" on 10.12
    if MacOS.version == :sierra || MacOS.version == :el_capitan
      ENV["SDKROOT"] = MacOS.sdk_path
    end

    args = std_cmake_args
    # Disable opportunistic linkage
    args << "-DCMAKE_DISABLE_FIND_PACKAGE_GDAL=ON" if build.without? "gdal"
    args << "-DCMAKE_DISABLE_FIND_PACKAGE_Jasper=ON" if build.without? "jasper"
    args << "-DCMAKE_DISABLE_FIND_PACKAGE_OpenEXR=ON" if build.without? "openexr"
    args << "-DCMAKE_DISABLE_FIND_PACKAGE_DCMTK=ON" if build.without? "dcmtk"
    args << "-DCMAKE_DISABLE_FIND_PACKAGE_RSVG=ON" if build.without? "librsvg"
    args << "-DCMAKE_DISABLE_FIND_PACKAGE_COLLADA=ON" if build.without? "collada-dom"
    args << "-DCMAKE_DISABLE_FIND_PACKAGE_FFmpeg=ON" if build.without? "ffmpeg"
    args << "-DCMAKE_DISABLE_FIND_PACKAGE_cairo=ON"
    args << "-DCMAKE_DISABLE_FIND_PACKAGE_TIFF=ON"

    args << "-DBUILD_DOCUMENTATION=" + (build.with?("docs") ? "ON" : "OFF")
    args << "-DCMAKE_CXX_FLAGS=-Wno-error=narrowing" # or: -Wno-c++11-narrowing

    if MacOS.prefer_64_bit?
      args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.arch_64_bit}"
      args << "-DOSG_DEFAULT_IMAGE_PLUGIN_FOR_OSX=imageio"
      args << "-DOSG_WINDOWING_SYSTEM=Cocoa"
    else
      args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.arch_32_bit}"
    end

    if build.with? "collada-dom"
      args << "-DCOLLADA_INCLUDE_DIR=#{Formula["collada-dom"].opt_include}/collada-dom2.4"
    end

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "doc_openscenegraph" if build.with? "docs"
      system "make", "install"
      doc.install Dir["#{prefix}/doc/OpenSceneGraphReferenceDocs/*"] if build.with? "docs"
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
