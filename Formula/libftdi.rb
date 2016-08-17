class Libftdi < Formula
  desc "Library to talk to FTDI chips"
  homepage "https://www.intra2net.com/en/developer/libftdi"
  url "https://www.intra2net.com/en/developer/libftdi/download/libftdi1-1.3.tar.bz2"
  sha256 "9a8c95c94bfbcf36584a0a58a6e2003d9b133213d9202b76aec76302ffaa81f4"

  bottle do
    cellar :any
    sha256 "81690eae8fa778df6a48557d03b154fbb3fe726d27edf8c8cccfb0f440810c46" => :el_capitan
    sha256 "fe679703a4c73cdae3d5c893c411ae4f080c113c9aef2e7c290c6c7386e2357d" => :yosemite
    sha256 "4049462256cac963b49c6cb430be7458cfad761af6db42cfef19ac33c8a8eca6" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "swig" => :build
  depends_on "libusb"
  depends_on "boost" => :optional
  depends_on "confuse" => :optional

  # Fix LINK_PYTHON_LIBRARY=OFF on OS X
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
