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
    rebuild 1
    sha256 cellar: :any, arm64_monterey: "e94c97f422890410db024c0024d844235f303716c8af1d54dad843ea84bcf3df"
    sha256 cellar: :any, arm64_big_sur:  "2931042f94c4881ab643856586c17ee22b2b63675f0d3aa0509c53752fb80857"
    sha256 cellar: :any, monterey:       "b29984650c71f50b533fb156265b10d6cfec4f3ad469a44675f6f0b7ee8fdd38"
    sha256 cellar: :any, big_sur:        "a072688c9fd543a73816acd77c8aa318bed1ec29f284ca4e8d3adb55304bacdb"
    sha256 cellar: :any, catalina:       "4c557e7daec07c756a8089460d2a0336e4e34db80c4709d61d5bd00f7da759fb"
    sha256               x86_64_linux:   "32c9cdff39692aaa329ae08d19b1dec41a9b21d8e4c73b35f599ed0a010f5a7d"
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
