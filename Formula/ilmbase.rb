class Ilmbase < Formula
  desc "OpenEXR ILM Base libraries (high dynamic-range image file format)"
  homepage "https://www.openexr.com/"
  url "https://github.com/openexr/openexr/archive/v2.4.1.tar.gz"
  sha256 "3ebbe9a8e67edb4a25890b98c598e9fe23b10f96d1416d6a3ff0732e99d001c1"

  bottle do
    sha256 "9f6c1102f28977b7ccf2db7812e9c050ee65c98bd789a96323db2a37373fffc4" => :catalina
    sha256 "00de5b40d528616efeef860feea3c6131e35313c586616b3ceb1a3d55707eaac" => :mojave
    sha256 "700a22b6523fc6bbe90ae67c4b1048b72304c9b6fb35e5162ee0321ae37a2dc2" => :high_sierra
  end

  depends_on "cmake" => :build

  # From https://github.com/openexr/openexr/commit/0b26a9dedda4924841323677f1ce0bce37bfbeb4.patch
  patch :DATA

  def install
    cd "IlmBase" do
      system "cmake", ".", *std_cmake_args
      system "make", "install"
      pkgshare.install %w[Half HalfTest Iex IexMath IexTest IlmThread Imath ImathTest]
    end
  end

  test do
    cd pkgshare/"IexTest" do
      system ENV.cxx, "-I#{include}/OpenEXR", "-I./", "-c",
             "testBaseExc.cpp", "-o", testpath/"test"
    end
  end
end

__END__
diff --git a/IlmBase/config/CMakeLists.txt b/IlmBase/config/CMakeLists.txt
index 508176a4..a6bff04a 100644
--- a/IlmBase/config/CMakeLists.txt
+++ b/IlmBase/config/CMakeLists.txt
@@ -71,9 +71,9 @@ if(ILMBASE_INSTALL_PKG_CONFIG)
   # use a helper function to avoid variable pollution, but pretty simple
   function(ilmbase_pkg_config_help pcinfile)
     set(prefix ${CMAKE_INSTALL_PREFIX})
-    set(exec_prefix ${CMAKE_INSTALL_BINDIR})
-    set(libdir ${CMAKE_INSTALL_LIBDIR})
-    set(includedir ${CMAKE_INSTALL_INCLUDEDIR})
+    set(exec_prefix "\${prefix}")
+    set(libdir "\${exec_prefix}/${CMAKE_INSTALL_LIBDIR}")
+    set(includedir "\${prefix}/${CMAKE_INSTALL_INCLUDEDIR}")
     set(LIB_SUFFIX_DASH ${ILMBASE_LIB_SUFFIX})
     if(TARGET Threads::Threads)
       # hrm, can't use properties as they end up as generator expressions
