class Gwenhywfar < Formula
  desc "Utility library required by aqbanking and related software"
  homepage "https://www.aquamaniac.de/rdm/projects/gwenhywfar"
  url "https://www.aquamaniac.de/rdm/attachments/download/630/gwenhywfar-5.14.1.tar.gz"
  sha256 "8916feaa99cb954f963f2cba8dd2dffe57cacf7f284daf00eab071aad6fe2ab3"
  license "LGPL-2.1-or-later"
  revision 1

  livecheck do
    url "https://www.aquamaniac.de/rdm/projects/gwenhywfar/files"
    regex(/href=.*?gwenhywfar[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 arm64_golden_gate: "3b92731f6fd0fe933cd77e872320900eda7feea94a0c410f2134d3dff9a08f44"
    sha256 arm64_tahoe:       "379b9a8b986fe25ea938d6d3a71bd9a71c8d6e4a36cd6f5ceef0ee38b7ee758b"
    sha256 arm64_sequoia:     "bcdf51cb7f01ea83217aaba3c44a5bc5eab04dfe3b1856f8d93f39ed277be915"
    sha256 arm64_linux:       "a110f1688dd95355dac2d7c2138e2073c5d3119338bc91395a798116a15613e8"
    sha256 x86_64_linux:      "6865071211fc5538357cd7f248d815ecc04b832d66cc837dc63e92cfb456d9cf"
  end

  depends_on "gettext" => :build
  depends_on "cmake" => :test
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "libgpg-error"
  depends_on "openssl@4"
  depends_on "pkgconf" # gwenhywfar-config needs pkg-config for execution
  depends_on "qtbase"

  on_macos do
    depends_on "gettext"
  end

  conflicts_with "go-size-analyzer", because: "both install `gsa` binaries"

  # Fix endianness handling for macos builds, emailed upstream about this patch
  patch :DATA

  deny_network_access!

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403
    if DevelopmentTools.clang_build_version >= 1500
      ENV.append_to_cflags "-Wno-int-conversion -Wno-incompatible-function-pointer-types"
    end

    # Workaround for Qt6 until next release which should have fix.
    # https://www.aquamaniac.de/rdm/projects/gwenhywfar/repository/revisions/49e4fb81dc41efd966115ff8a610a84495b330e4
    ln_s buildpath/"gui/qt5", buildpath/"gui/qt6"

    inreplace "gwenhywfar-config.in.in", "@PKG_CONFIG@", "pkg-config"
    guis = ["cpp", "qt6"]
    guis << "cocoa" if OS.mac?
    system "./configure", "--disable-silent-rules",
                          "--with-guis=#{guis.join(" ")}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <gwenhywfar/gwenhywfar.h>

      int main()
      {
        GWEN_Init();
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}/gwenhywfar5", "-L#{lib}", "-lgwenhywfar", "-o", "test_c"
    system "./test_c"

    system ENV.cxx, "test.c", "-I#{include}/gwenhywfar5", "-L#{lib}", "-lgwenhywfar", "-o", "test_cpp"
    system "./test_cpp"

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.29)
      project(test_gwen)

      find_package(Qt6 REQUIRED Core Widgets)
      find_package(gwenhywfar REQUIRED)
      find_package(gwengui-cpp REQUIRED)
      find_package(gwengui-qt6 REQUIRED)

      add_executable(${PROJECT_NAME} test.c)

      target_link_libraries(${PROJECT_NAME} PUBLIC
                      gwenhywfar::core
                      gwenhywfar::gui-cpp
                      gwenhywfar::gui-qt6
      )
    CMAKE

    system "cmake", testpath.to_s, *std_cmake_args
    system "make"
  end
end

__END__
diff --git a/src/base/endianfns.h b/src/base/endianfns.h
index 2db9731..1d73968 100644
--- a/src/base/endianfns.h
+++ b/src/base/endianfns.h
@@ -28,6 +28,7 @@
 #include <gwenhywfar/gwenhywfarapi.h>


+
 #if GWENHYWFAR_SYS_IS_WINDOWS
 /* assume little endian for now (is there any big endian Windows system??) */
 #  define GWEN_ENDIAN_LE16TOH(x) (x)
@@ -39,8 +40,14 @@
 #  define GWEN_ENDIAN_LE64TOH(x) (x)
 #  define GWEN_ENDIAN_HTOLE64(x) (x)
 #else
-/* for Linux and others use definitions from endian.h */
-#  include <endian.h>
+/* Include portable_endian.h for cross-platform support */
+#  if __has_include("portable_endian.h")
+#    include "portable_endian.h"
+#  elif __has_include(<endian.h>)
+#    include <endian.h>
+#  else
+#    error "Neither portable_endian.h nor endian.h found. Cannot determine endianness."
+#  endif

 #  define GWEN_ENDIAN_LE16TOH(x) le16toh(x)
 #  define GWEN_ENDIAN_HTOLE16(x) htole16(x)
@@ -52,7 +59,4 @@
 #  define GWEN_ENDIAN_HTOLE64(x) htole64(x)
 #endif

-
-
-
 #endif
