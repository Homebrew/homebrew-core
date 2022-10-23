class Mgba < Formula
  desc "Game Boy Advance emulator"
  homepage "https://mgba.io/"
  url "https://github.com/mgba-emu/mgba/archive/0.10.0.tar.gz"
  sha256 "e2d66d9ce7c51b1ef3b339b04e871287bf166f6a1d7125ef112dbf53ab8bbd48"
  license "MPL-2.0"
  head "https://github.com/mgba-emu/mgba.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_monterey: "fda5f57d8ace572ad6ff1b3457a47077882140d707a1076a8c1a32938ca43ee8"
    sha256 arm64_big_sur:  "23038b35ba70a5a7a23847607ad84706d14bc507854cdb946a9e47cf3dab6fbe"
    sha256 monterey:       "7c3646e7cbd567454301e2917e3e9286624d565d2ba200396f6d376374ff881c"
    sha256 big_sur:        "eebee6cce324280243304e19398b22a19bd60efbd04dbd0658fe2285c7e724ca"
    sha256 catalina:       "9b0054aa6bb75a4afbb22d413e241e54c2fb77243ed5fc712bd74dcc8022f527"
    sha256 x86_64_linux:   "4c2aed6811fbc6349bf76f323e935f3c21d841b48fb50ec7d0d55aff9aba4727"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "libepoxy"
  depends_on "libpng"
  depends_on "libzip"
  depends_on "lua"
  depends_on "qt@5"
  depends_on "sdl2"

  uses_from_macos "sqlite"

  on_macos do
    depends_on "libelf" => :build
  end

  on_linux do
    depends_on "elfutils"
  end

  # discussions in here, https://github.com/mgba-emu/mgba/issues/2700
  # commit reference, https://github.com/mgba-emu/mgba/commit/981d01134b15c1d8214d9a7e5944879852588063
  patch :DATA

  def install
    # Install .app bundle into prefix, not prefix/Applications
    inreplace "src/platform/qt/CMakeLists.txt", "Applications", "."

    system "cmake", ".", *std_cmake_args
    system "make", "install"

    # Replace SDL frontend binary with a script for running Qt frontend
    # -DBUILD_SDL=OFF would be easier, but disable joystick support in Qt frontend
    rm bin/"mgba"
    if OS.mac?
      bin.write_exec_script "#{prefix}/mGBA.app/Contents/MacOS/mGBA"
    else
      mv bin/"mgba-qt", bin/"mGBA"
    end
  end

  test do
    system "#{bin}/mGBA", "-h"
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index ce8e4d687..a8116d3ea 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -718,8 +718,13 @@ if (USE_LZMA)
 endif()

 if(USE_EPOXY)
-	list(APPEND FEATURE_SRC ${CMAKE_CURRENT_SOURCE_DIR}/src/platform/opengl/gl.c ${CMAKE_CURRENT_SOURCE_DIR}/src/platform/opengl/gles2.c)
-	list(APPEND FEATURE_DEFINES BUILD_GL BUILD_GLES2 BUILD_GLES3)
+	if(APPLE AND MACOSX_SDK VERSION_GREATER 10.14)
+		list(APPEND FEATURE_SRC ${CMAKE_CURRENT_SOURCE_DIR}/src/platform/opengl/gles2.c)
+		list(APPEND FEATURE_DEFINES BUILD_GLES2 BUILD_GLES3)
+	else()
+		list(APPEND FEATURE_SRC ${CMAKE_CURRENT_SOURCE_DIR}/src/platform/opengl/gl.c ${CMAKE_CURRENT_SOURCE_DIR}/src/platform/opengl/gles2.c)
+		list(APPEND FEATURE_DEFINES BUILD_GL BUILD_GLES2 BUILD_GLES3)
+	endif()
 	list(APPEND FEATURES EPOXY)
 	include_directories(AFTER ${EPOXY_INCLUDE_DIRS})
 	link_directories(${EPOXY_LIBRARY_DIRS})
