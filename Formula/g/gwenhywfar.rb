class Gwenhywfar < Formula
  desc "Utility library required by aqbanking and related software"
  homepage "https://www.aquamaniac.de/rdm/projects/gwenhywfar"
  url "https://www.aquamaniac.de/rdm/attachments/download/662/gwenhywfar-5.14.3.tar.gz"
  sha256 "be1371a668d4d42f113f9dbebd850a66c63437037a027d3c1148afff5503998b"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  livecheck do
    url "https://www.aquamaniac.de/rdm/projects/gwenhywfar/files"
    regex(/href=.*?gwenhywfar[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 arm64_golden_gate: "210d28b8bc1231fb24225a099f0c5ba83e0fdd53f1ea75134bcc77a3d8ab1932"
    sha256 arm64_tahoe:       "2693677711d7c3eed0981283783a3978e4c9d7b440d9831609cf3429c2e6bb73"
    sha256 arm64_sequoia:     "3bed7f030e8a66acd8a255872080dc1c6c0339e607429886bc6acdff3ffba417"
    sha256 arm64_linux:       "890c6df806158aa78c6c14ad7dc6481b5136dff0d0cf5a25f887a3f243f5a67a"
    sha256 x86_64_linux:      "3024113d904408059bacbebcf6bf14fb67d52efc323838c4377b5ffcc691820c"
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
