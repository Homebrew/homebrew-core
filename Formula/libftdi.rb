class Libftdi < Formula
  desc "Library to talk to FTDI chips"
  homepage "https://www.intra2net.com/en/developer/libftdi"
  url "https://www.intra2net.com/en/developer/libftdi/download/libftdi1-1.3.tar.bz2"
  sha256 "9a8c95c94bfbcf36584a0a58a6e2003d9b133213d9202b76aec76302ffaa81f4"

  bottle do
    cellar :any
    sha256 "540e617ca5d42d5b647d793b433b4c75768b735a14fc33bec8c368cb1de3838c" => :sierra
    sha256 "37772d45b6844929547144cb7afa28efcd77da77a517047a6f2e3f70da108385" => :el_capitan
    sha256 "81a94352b47d901ba85e957f3d1d21f6cf797e3775503fb6326b69d4e30ecedc" => :yosemite
    sha256 "45365f61af1f24bc879361233fd88422f351887e328dcbed803121aa859189c8" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "swig" => :build
  depends_on "libusb"
  depends_on "boost" => :optional
  depends_on "confuse" => :optional

  # Fix LINK_PYTHON_LIBRARY=OFF on macOS
  # https://www.mail-archive.com/libftdi@developer.intra2net.com/msg03013.html
  patch :DATA

  def install
    mkdir "libftdi-build" do
      system "cmake", "..", "-DLINK_PYTHON_LIBRARY=OFF", *std_cmake_args
      system "make", "install"
      (libexec/"bin").install "examples/find_all"
    end
  end

  test do
    system libexec/"bin/find_all"
    system "python", pkgshare/"examples/simple.py"
  end
end
__END__
diff --git a/python/CMakeLists.txt b/python/CMakeLists.txt
index 8b52745..31ef1c6 100644
--- a/python/CMakeLists.txt
+++ b/python/CMakeLists.txt
@@ -30,6 +30,8 @@ if ( SWIG_FOUND AND PYTHONLIBS_FOUND AND PYTHONINTERP_FOUND )

   if ( LINK_PYTHON_LIBRARY )
     swig_link_libraries ( ftdi1 ${PYTHON_LIBRARIES} )
+  elseif( APPLE )
+    set_target_properties ( ${SWIG_MODULE_ftdi1_REAL_NAME} PROPERTIES LINK_FLAGS "-undefined dynamic_lookup" )
   endif ()

   set_target_properties ( ${SWIG_MODULE_ftdi1_REAL_NAME} PROPERTIES NO_SONAME ON )
