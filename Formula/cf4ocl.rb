class Cf4ocl < Formula
  desc "C Framework for OpenCL"
  homepage "https://nunofachada.github.io/cf4ocl/"
  url "https://github.com/nunofachada/cf4ocl/archive/v2.1.0.tar.gz"
  sha256 "662c2cc4e035da3e0663be54efaab1c7fedc637955a563a85c332ac195d72cfa"
  license "LGPL-3.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "721f4e1699a3909dff50586705fe8d1ed67b1ee67d34b653f84d76ead782e345"
    sha256 cellar: :any,                 arm64_big_sur:  "082e1894c94269ec1541fd6148a1dfca0f7385e64fb5e24dd0a3ed70563df603"
    sha256 cellar: :any,                 monterey:       "e2a0fad26922fc1f84a90837426ff2fcdffa20467cb55a6818a5820c88fb355a"
    sha256 cellar: :any,                 big_sur:        "c9d99d7a996bc2c2e1ed6c94bd3639ec5bd97a09e6834a260cbd0a165832f094"
    sha256 cellar: :any,                 catalina:       "42086ab65ee844ca3e982c19592ca56fc4d7e0c1417fc749585dc4f24426c1b5"
    sha256 cellar: :any,                 mojave:         "bac407173815fb9bed500a83fb8c2cac4c599a4b1c35a6a619adbfa746817162"
    sha256 cellar: :any,                 high_sierra:    "d5903425babf74b3f3af6b4aebf7e0c583bf0729d15799b4a99208141ca80b5a"
    sha256 cellar: :any,                 sierra:         "dfbd0e6e303f7f8ff286e38b98562cbf9b18ac880070fcfa19240b0b9c8d4a2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28305a6cfb69ccd57b94203bb43beb18b29e3d4fc0eebbe37b04292660516da8"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"

  on_linux do
    depends_on "opencl-headers" => :build
    depends_on "ocl-icd"
    depends_on "pocl"
  end

  # Fix build failure on Linux caused by undefined Windows-only constants.
  # Upstreamed here: https://github.com/nunofachada/cf4ocl/pull/40
  patch :DATA

  def install
    args = *std_cmake_args
    args << "-DBUILD_TESTS=OFF"
    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system bin/"ccl_devinfo"
  end
end

__END__
diff --git a/src/lib/ccl_event_wrapper.c b/src/lib/ccl_event_wrapper.c
index 0bfbf8a..0ba8bf9 100644
--- a/src/lib/ccl_event_wrapper.c
+++ b/src/lib/ccl_event_wrapper.c
@@ -282,6 +282,7 @@ const char* ccl_event_get_final_name(CCLEvent* evt) {
 			case CL_COMMAND_GL_FENCE_SYNC_OBJECT_KHR:
 				final_name = "GL_FENCE_SYNC_OBJECT_KHR";
 				break;
+            #if defined(__MSC_VER)
 			case CL_COMMAND_ACQUIRE_D3D10_OBJECTS_KHR:
 				final_name = "ACQUIRE_D3D10_OBJECTS_KHR";
 				break;
@@ -300,6 +301,7 @@ const char* ccl_event_get_final_name(CCLEvent* evt) {
 			case CL_COMMAND_RELEASE_D3D11_OBJECTS_KHR:
 				final_name = "RELEASE_D3D11_OBJECTS_KHR";
 				break;
+            #endif
 			case CL_COMMAND_ACQUIRE_EGL_OBJECTS_KHR:
 				final_name = "ACQUIRE_EGL_OBJECTS_KHR";
 				break;
diff --git a/src/lib/ccl_oclversions.h b/src/lib/ccl_oclversions.h
index 4e82c9f..598a7e6 100644
--- a/src/lib/ccl_oclversions.h
+++ b/src/lib/ccl_oclversions.h
@@ -33,7 +33,7 @@
 	#include <OpenCL/opencl.h>
 #else
 	#include <CL/opencl.h>
-	#ifdef CL_VERSION_1_2
+	#if defined(CL_VERSION_1_2) && defined(__MSC_VER)
 		#include <CL/cl_dx9_media_sharing.h>
 	#endif
 #endif
