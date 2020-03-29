class Ilmbase < Formula
  desc "OpenEXR ILM Base libraries (high dynamic-range image file format)"
  homepage "https://www.openexr.com/"
  url "https://github.com/openexr/openexr/archive/v2.4.1.tar.gz"
  sha256 "3ebbe9a8e67edb4a25890b98c598e9fe23b10f96d1416d6a3ff0732e99d001c1"

  bottle do
    sha256 "283030498c0023d380c9df4450377cf6217fb59a826e436244fa695020ed1642" => :catalina
    sha256 "c3a7cc2853f2e189eda220df9f8452ce76aa809e193b50f601dd3166d83a8b04" => :mojave
    sha256 "28241d4f2028ea2f0a7bb9d2a17cd7ed717259a194e60d51463f1216fd213ea6" => :high_sierra
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
