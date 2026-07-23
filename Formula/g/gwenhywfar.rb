class Gwenhywfar < Formula
  desc "Utility library required by aqbanking and related software"
  homepage "https://www.aquamaniac.de/rdm/projects/gwenhywfar"
  url "https://www.aquamaniac.de/rdm/attachments/download/630/gwenhywfar-5.14.1.tar.gz"
  sha256 "8916feaa99cb954f963f2cba8dd2dffe57cacf7f284daf00eab071aad6fe2ab3"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://www.aquamaniac.de/rdm/projects/gwenhywfar/files"
    regex(/href=.*?gwenhywfar[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 arm64_tahoe:   "0064b8768502f583fd8ca6efb644af7b4951e36157f6f88951d7d8d617e98db2"
    sha256 arm64_sequoia: "00562b743c4f8dad11ce5746934cad1ecd89d7c7794fb1b1536f8735be528210"
    sha256 arm64_sonoma:  "f48b5464707113f0ea72a518904a46cf6967904ab82e7ceaa5f0084a03aef71a"
    sha256 sonoma:        "d248c00aca75c6333b9edfd2d89f0e33f4d49835d53dd1f95ed723741751ff4c"
    sha256 arm64_linux:   "6f5f7d2f098ca5b058b487c890bb4691921f0d9bed0cc86f74944ac60b02545e"
    sha256 x86_64_linux:  "8141ecaa807eefbcc2e17f6989c4025788aae4f3111b8d83b40e04abfb19813f"
  end

  depends_on "gettext" => :build
  depends_on "cmake" => :test
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "libgpg-error"
  depends_on "openssl@3"
  depends_on "pkgconf" # gwenhywfar-config needs pkg-config for execution
  depends_on "qtbase"

  on_macos do
    depends_on "gettext"
  end

  conflicts_with "go-size-analyzer", because: "both install `gsa` binaries"

  # Fix endianness handling for macos builds, emailed upstream about this patch
  patch :DATA

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
