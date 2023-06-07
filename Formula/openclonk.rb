class Openclonk < Formula
  desc "Multiplayer action game"
  homepage "https://www.openclonk.org/"
  license "ISC"
  revision 4

  stable do
    url "https://www.openclonk.org/builds/release/7.0/openclonk-7.0-src.tar.bz2"
    sha256 "bc1a231d72774a7aa8819e54e1f79be27a21b579fb057609398f2aa5700b0732"

    depends_on "glew"

    on_linux do
      depends_on "gtk+3"
      depends_on "libx11"
    end

    # Fix macOS OpenGL initialization. Remove in release after v8.1.
    patch do
      url "https://github.com/openclonk/openclonk/commit/1487ff02273975e9a7ea5f3046884c2ebf254333.patch?full_index=1"
      sha256 "d42821d13bc698435058fbd9135c5e8eb178c835afbc8fca8c6b76bdecbcc563"
    end

    # Fix Linux build to help find alut.h. Remove in next release.
    patch do
      url "https://github.com/openclonk/openclonk/commit/15e58576894f5735af390164eb15e609344f9331.patch?full_index=1"
      sha256 "af84dc82b85c2b2ae63738badf604745002ddeb2e285fb7911b7ccdf5d4497eb"
    end

    # Fix build failure with newer GCC because of missing #include <limits>
    # TODO: submit to upstream GitHub repo
    patch :DATA
  end

  livecheck do
    url "https://www.openclonk.org/download/"
    regex(/href=.*?openclonk[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "69f947dc71896c10d2f3459c7550609b154b65ad325e7c398567d83927bc0bb7"
    sha256 cellar: :any, arm64_monterey: "8df6fbb4658c855b62269b2e2e8662e3ece958a642ff2f364190466660dd4f12"
    sha256 cellar: :any, arm64_big_sur:  "1be50cd57fe2284eab644c8f7b96d2d73e41433bcee445c9ee4e32ecd624ed23"
    sha256 cellar: :any, ventura:        "2edfeeffc28542ed25b07268667d0901a3682c7f65eb75bcfada1e1667271bc5"
    sha256 cellar: :any, monterey:       "c4f8dfb61e0ebc30ff721e326710424c256cb33bced493c9bcee7badf44e53fc"
    sha256 cellar: :any, big_sur:        "b863f8f7a26d65cc4524210a7d141b5a96948ce1a795268473c5ee4bfd640f35"
    sha256 cellar: :any, catalina:       "805a680c7377bc81ca2b1e8207a68348ebcbec5fb0efc036e30139626874494d"
    sha256               x86_64_linux:   "352052e8b19d4d3f9e7f311ae5f97353ad1c6ba8cb8ee5c43ead3f7bb8cf5fbb"
  end

  head do
    url "https://github.com/openclonk/openclonk.git", branch: "master"

    depends_on "libepoxy"

    uses_from_macos "curl"

    on_linux do
      depends_on "miniupnpc"
      depends_on "sdl2"
    end
  end

  depends_on "cmake" => :build
  depends_on "freealut"
  depends_on "freetype"
  depends_on "jpeg-turbo"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "tinyxml"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libxrandr"
    depends_on "mesa"
    depends_on "openal-soft"
  end

  def install
    # Disable copying libraries into macOS app bundle by overwriting script
    File.open(buildpath/"tools/osx_bundle_libs", "w") { |f| f.puts "#!/bin/bash" }

    # Remove unneeded bundled library to avoid default fallback in build
    (buildpath/"thirdparty/tinyxml").rmtree

    # Modify Linux install location for openclonk binary to bin directory
    inreplace "CMakeLists.txt", "install(TARGETS openclonk DESTINATION games)",
                                "install(TARGETS openclonk DESTINATION bin)"

    ENV.cxx11
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    return unless OS.mac?

    bin.write_exec_script prefix/"openclonk.app/Contents/MacOS/openclonk"
    bin.install Dir[prefix/"c4*"]
  end

  test do
    system bin/"c4group"
  end
end

__END__
diff --git a/src/gui/C4ScriptGuiWindow.cpp b/src/gui/C4ScriptGuiWindow.cpp
index 785e168..1d2c467 100755
--- a/src/gui/C4ScriptGuiWindow.cpp
+++ b/src/gui/C4ScriptGuiWindow.cpp
@@ -42,6 +42,7 @@
 #include <C4Viewport.h>

 #include <cmath>
+#include <limits>

 // Adds some helpful logs for hunting control & menu based desyncs.
 //#define MenuDebugLogF(...) DebugLogF(__VA_ARGS__)
