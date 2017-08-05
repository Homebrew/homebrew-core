class Mgba < Formula
  desc "Game Boy Advance emulator"
  homepage "https://mgba.io/"
  revision 3
  head "https://github.com/mgba-emu/mgba.git"

  stable do
    url "https://github.com/mgba-emu/mgba/archive/0.5.2.tar.gz"
    sha256 "3d9fda762e6e0dd26ffbd3cbaa5365dc7ca7ed324cee5c65b7c85eaa3c37c4f3"

    # Remove for > 0.5.2
    # Upstream commit from 18 Jan 2017 "Feature: Support ImageMagick 7"
    # https://github.com/mgba-emu/mgba/commit/2e3daaedc208824c9b8a54480bd614160cdda9e7
    # Can't use the commit itself as a patch since it doesn't apply cleanly
    patch :DATA
  end

  bottle do
    cellar :any
    sha256 "e4fb392e7a67655615e215ac7ffe4dbf8923b7cafe1fb0000a7db9b290e491cc" => :sierra
    sha256 "7ab161a44b6081c6a9f9ebc6ffcbf9a0e7b03d58c5815b2cbf05035b3ed63f99" => :el_capitan
    sha256 "49dec7dc507d9048599cdd75379cff76789c0e6eb65a7a5c6da5451381008f7b" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "imagemagick"
  depends_on "libepoxy"
  depends_on "libpng"
  depends_on "libzip"
  depends_on "qt"
  depends_on "sdl2"

  def install
    inreplace "src/platform/qt/CMakeLists.txt" do |s|
      # Avoid framework installation via tools/deploy-macosx.py
      s.gsub! /(add_custom_command\(TARGET \${BINARY_NAME}-qt)/, '#\1'
      # Install .app bundle into prefix, not prefix/Applications
      s.gsub! "Applications", "."
    end

    system "cmake", ".", *std_cmake_args
    system "make", "install"

    # Replace SDL frontend binary with a script for running Qt frontend
    # -DBUILD_SDL=OFF would be easier, but disable joystick support in Qt frontend
    rm bin/"mgba"
    bin.write_exec_script "#{prefix}/mGBA.app/Contents/MacOS/mGBA"
  end

  test do
    system "#{bin}/mGBA", "-h"
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 3812082..6be1599 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -322,6 +322,7 @@ if(HAVE_UMASK)
 endif()

 # Feature dependencies
+set(FEATURE_DEFINES)
 set(FEATURES)
 if(CMAKE_SYSTEM_NAME MATCHES .*BSD)
	set(LIBEDIT_LIBRARIES -ledit)
@@ -431,11 +432,16 @@ if(USE_MAGICK)
	list(APPEND FEATURE_SRC "${CMAKE_CURRENT_SOURCE_DIR}/src/feature/imagemagick/imagemagick-gif-encoder.c")
	list(APPEND DEPENDENCY_LIB ${MAGICKWAND_LIBRARIES})
	string(REGEX MATCH "^[0-9]+\\.[0-9]+" MAGICKWAND_VERSION_PARTIAL ${MagickWand_VERSION})
+	string(REGEX MATCH "^[0-9]+" MAGICKWAND_VERSION_MAJOR ${MagickWand_VERSION})
	if(${MAGICKWAND_VERSION_PARTIAL} EQUAL "6.7")
		set(MAGICKWAND_DEB_VERSION "5")
+	elseif(${MagickWand_VERSION} EQUAL "6.9.7")
+		set(MAGICKWAND_DEB_VERSION "-6.q16-3")
	else()
		set(MAGICKWAND_DEB_VERSION "-6.q16-2")
	endif()
+	list(APPEND FEATURE_DEFINES MAGICKWAND_VERSION_MAJOR=${MAGICKWAND_VERSION_MAJOR})
+
	set(CPACK_DEBIAN_PACKAGE_DEPENDS "${CPACK_DEBIAN_PACKAGE_DEPENDS},libmagickwand${MAGICKWAND_DEB_VERSION}")
 endif()

@@ -595,7 +601,6 @@ if(USE_DEBUGGERS)
	list(APPEND FEATURES DEBUGGERS)
 endif()

-set(FEATURE_DEFINES)
 foreach(FEATURE IN LISTS FEATURES)
	list(APPEND FEATURE_DEFINES "USE_${FEATURE}")
 endforeach()
diff --git a/src/feature/imagemagick/imagemagick-gif-encoder.h b/src/feature/imagemagick/imagemagick-gif-encoder.h
index 13505e6..842cad9 100644
--- a/src/feature/imagemagick/imagemagick-gif-encoder.h
+++ b/src/feature/imagemagick/imagemagick-gif-encoder.h
@@ -15,7 +15,11 @@ CXX_GUARD_START
 #define MAGICKCORE_HDRI_ENABLE 0
 #define MAGICKCORE_QUANTUM_DEPTH 8

+#if MAGICKWAND_VERSION_MAJOR >= 7
+#include <MagickWand/MagickWand.h>
+#else
 #include <wand/MagickWand.h>
+#endif

 struct ImageMagickGIFEncoder {
	struct mAVStream d;
