class Cf4ocl < Formula
  desc "C Framework for OpenCL"
  homepage "https://nunofachada.github.io/cf4ocl/"
  url "https://github.com/nunofachada/cf4ocl/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "662c2cc4e035da3e0663be54efaab1c7fedc637955a563a85c332ac195d72cfa"
  license all_of: ["LGPL-3.0-or-later", "GPL-3.0-or-later"]
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "1a609601f5b9aa94b1ae423edc608e7145c727f27a83107288eeef900a3dc4aa"
    sha256 cellar: :any,                 arm64_sonoma:   "c4ad35eb918184b01d089142977aa5ed79a8d66dca5159a91b1b95df9bcec116"
    sha256 cellar: :any,                 arm64_ventura:  "e48f59a0665212145258089b5c0f9a63eb539348b30aeb76ca4d77fcc2c8468f"
    sha256 cellar: :any,                 arm64_monterey: "fcab7173eab0b7c577e19e44c2a05f285a095a1c3045b5ce7e64d1101f42a957"
    sha256 cellar: :any,                 sonoma:         "2592b539d6a3f8c08b93e8c0d8d477ef49da07f094a8719729b44fd97eb7273a"
    sha256 cellar: :any,                 ventura:        "002efc993e534155ef8c5fc6446d7c9112e717e9f3babc2ca2d785456aa5e680"
    sha256 cellar: :any,                 monterey:       "a245ed9722b10e435d68cf38a28dc92e6d40c3bc9f1c47a698f00ca1ae562362"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9e0c414903014a5ff0feadf1dea46a6bf9ebf725e94c95cbe1af659789e864c"
  end

  disable! date: "2025-01-18", because: :repo_archived

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "opencl-headers" => :build
    depends_on "opencl-icd-loader"
    depends_on "pocl"
  end

  # Fix build failure on Linux caused by undefined Windows-only constants.
  # Upstreamed here: https://github.com/nunofachada/cf4ocl/pull/40
  patch :DATA

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # OpenCL is not supported on virtualized arm64 macOS so will return error code
    result = (OS.mac? && Hardware::CPU.arm? && Hardware::CPU.virtualized?) ? 15 : 0

    assert_match "Platform #0:", shell_output("#{bin}/ccl_devinfo 2>&1", result)
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
