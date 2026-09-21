class Dislocker < Formula
  desc "FUSE driver to read/write Windows' BitLocker-ed volumes"
  homepage "https://github.com/Aorimn/dislocker"
  url "https://github.com/Aorimn/dislocker/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "8d5275577c44f2bd87f6e05dd61971a71c0e56a9cbedf000bd38deadd8b6c1e6"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_linux:  "6fc800d70967d83257c8716d1a802960c44a892f7a3594db882737cceebeb5c3"
    sha256 cellar: :any, x86_64_linux: "5656ee57b450b544d660941fa9682cc999dcde547cd4b3911f5f5660c82a4b71"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libfuse"
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "openssl@4"

  # Backport support for mbedtls 3.x
  patch do
    url "https://github.com/Aorimn/dislocker/commit/2cfbba2c8cc07e529622ba134d0a6982815d2b30.patch?full_index=1"
    sha256 "07e0e3cac520a04a478f1f08d612340fc2743fd492b0835c7fb41cfdb5ef4244"
    type :backport
  end

  # Backport support for libfuse 3
  patch do
    url "https://github.com/Aorimn/dislocker/commit/7744f87c75fcfeeb414d0957771042b10fb64e62.patch?full_index=1"
    sha256 "63ed9e08ebdad3ee97eb5fc0f3bed67231043b8505a007580d3bc3051c4daa7f"
    type :backport
  end
  patch do
    url "https://github.com/Aorimn/dislocker/commit/b6aa30ae21a631ef2300f230437fe6a8ebf1ab70.patch?full_index=1"
    sha256 "fee637f1af9c81f0426925a16c91560fed61ef701913f52fe451516de33183ac"
    type :backport
  end
  patch do
    url "https://github.com/Aorimn/dislocker/commit/7b14a6aa71cad78648443fdec81a5e557903b961.patch?full_index=1"
    sha256 "80d0db6ba8dfb6f6fc60e94eeb75ab9284606b3e5dba14eaf3460335b9a0b8ee"
    type :backport
  end

  # Backport fix for CMake 4
  patch do
    url "https://github.com/Aorimn/dislocker/commit/337d05dc7447436539f2fb481eef0e528a000b66.patch?full_index=1"
    sha256 "7bec70c3528e34949c31ace9a90ee36829fadc7d31a8ad99b707c01d98c74afb"
    type :backport
  end

  # Backport support for disabling Ruby
  patch do
    url "https://github.com/Aorimn/dislocker/commit/05cd96b1890d3bd4c6ea472edcc2e7b329e4e2e4.patch?full_index=1"
    sha256 "92876b8af81d4f63627936b85d31ba83388798bf91f329e39376d2deb5df41f4"
    type :backport
  end

  # Backport support for OpenSSL
  patch :DATA # https://github.com/Aorimn/dislocker/commit/e749eade55f242d03fb9d10c05ff4b11c66dcbbe
  patch do
    url "https://github.com/Aorimn/dislocker/commit/44cc1ded330f8202358e97ddc14a90ffe363a8e7.patch?full_index=1"
    sha256 "65413003475eb682748ebce478468414b82e892785d904dae2254915a3f0e119"
    type :backport
  end
  patch do
    url "https://github.com/Aorimn/dislocker/commit/9bfd16724f3109e6e964f407391200c63c8dc9f9.patch?full_index=1"
    sha256 "af8d4dcd8b7a6b4a1d74310ce6c1b179ecc5df4c944f1183dcf0c0ba9b6b6033"
    type :backport
  end
  patch do
    url "https://github.com/Aorimn/dislocker/commit/49ecf37cdb702d8366c24b10fb58ba2764315348.patch?full_index=1"
    sha256 "e99ccbe3495aa00890ed25a15035c26f6780d6cda8bbabaf92bc7fdddfa07bd2"
    type :backport
  end

  def install
    args = %w[
      -DCRYPTO_BACKEND=openssl
      -DWITH_RUBY=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"dislocker", "-h"
  end
end

__END__
diff --git a/include/dislocker/ssl_bindings.h.in b/include/dislocker/ssl_bindings.h
rename from include/dislocker/ssl_bindings.h.in
rename to include/dislocker/ssl_bindings.h
diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index c578e35..7337db6 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -116,14 +116,8 @@ endif()
 # Libraries
 set (CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake)
 
-find_package (PolarSSL REQUIRED)
-if(POLARSSL_FOUND  AND  POLARSSL_INCLUDE_DIRS  AND  POLARSSL_LIBRARIES)
-	include_directories (${POLARSSL_INCLUDE_DIRS})
-	set (LIB ${LIB} ${POLARSSL_LIBRARIES})
-	configure_file (${PROJECT_SOURCE_DIR}/include/dislocker/ssl_bindings.h.in ${PROJECT_SOURCE_DIR}/include/dislocker/ssl_bindings.h ESCAPE_QUOTES @ONLY)
-else()
-	return ()
-endif()
+find_package (MbedTLS 3 REQUIRED)
+set (LIB ${LIB} MbedTLS::mbedcrypto)
 
 # Ruby bindings
 set(WITH_RUBY "AUTO" CACHE STRING "Enable Ruby bindings. Valid values are ON, OFF, or AUTO")
