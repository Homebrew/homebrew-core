class Mgba < Formula
  desc "Game Boy Advance emulator"
  homepage "https://mgba.io/"
  revision 1
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
    sha256 "2dd5217c3983abd7a89908647251ab1dd9784e385b481325ebffdb559f01e344" => :sierra
    sha256 "e40931849cc341855777add7e5b4b5fae4ae33bb5db044f52d90b6b423824429" => :el_capitan
    sha256 "a57adec40fb57cd57d37eb540fb930e097cd4b9286209addf45167e5d7fa7e69" => :yosemite
  end

  deprecated_option "with-qt5" => "with-qt"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg" => :recommended
  depends_on "imagemagick" => :recommended
  depends_on "libepoxy" => :recommended
  depends_on "libpng" => :recommended
  depends_on "libzip" => :recommended
  depends_on "qt" => :recommended
  depends_on "sdl2"

  def install
    inreplace "src/platform/qt/CMakeLists.txt" do |s|
      # Avoid framework installation via tools/deploy-macosx.py
      s.gsub! /(add_custom_command\(TARGET \${BINARY_NAME}-qt)/, '#\1'
      # Install .app bundle into prefix, not prefix/Applications
      s.gsub! "Applications", "."
    end

    cmake_args = []
    cmake_args << "-DUSE_EPOXY=OFF"  if build.without? "libepoxy"
    cmake_args << "-DUSE_MAGICK=OFF" if build.without? "imagemagick"
    cmake_args << "-DUSE_FFMPEG=OFF" if build.without? "ffmpeg"
    cmake_args << "-DUSE_PNG=OFF"    if build.without? "libpng"
    cmake_args << "-DUSE_LIBZIP=OFF" if build.without? "libzip"
    cmake_args << "-DBUILD_QT=OFF"   if build.without? "qt"

    system "cmake", ".", *cmake_args, *std_cmake_args
    system "make", "install"
    if build.with? "qt"
      # Replace SDL frontend binary with a script for running Qt frontend
      # -DBUILD_SDL=OFF would be easier, but disable joystick support in Qt frontend
      rm "#{bin}/mgba"
      bin.write_exec_script "#{prefix}/mGBA.app/Contents/MacOS/mGBA"
    end
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
