class Qmmp < Formula
  desc "Qt-based Multimedia Player"
  homepage "https://qmmp.ylsoftware.com/"
  url "https://qmmp.ylsoftware.com/files/qmmp/2.1/qmmp-2.1.9.tar.bz2"
  sha256 "b59f7a378b521d4a6d2b5c9e37a35c3494528bf0db85b24caddf3e1a1c9c3a37"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://qmmp.ylsoftware.com/downloads.php"
    regex(/href=.*?qmmp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "5fdf9499f3a80c471492e03df8a755be67e31799abced5e32542e6a67ef19a78"
    sha256 arm64_ventura:  "6d75b373d7825e6a97716f97a274608920ff7aa81f50973446e8cc5b82bba137"
    sha256 arm64_monterey: "df531f89e2a5b959a6637041378e9da53c0a8f38a6bd2e1bbdb04c073eef4d6c"
    sha256 sonoma:         "c0c251c58bfb213e98db5ab335cc245ac2c253239461753b361da1e1100c597f"
    sha256 ventura:        "28648897ea50fcc6ef3a119e2c351b6f44e8c503a9906512f6902e2d5c4e2949"
    sha256 monterey:       "48fd7d7f632424e93665d9d894b4c1734aae1d109eb12e8180053d5fecd77c33"
    sha256 x86_64_linux:   "abd12bd0ae508464ea099d7ea64f0813f15e388396cfdcca23e152a5168efbe3"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  # TODO: on linux: pipewire
  depends_on "faad2"
  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "game-music-emu"
  depends_on "jack"
  depends_on "libarchive"
  depends_on "libbs2b"
  depends_on "libcddb"
  depends_on "libcdio"
  depends_on "libmms"
  depends_on "libmodplug"
  depends_on "libogg"
  depends_on "libsamplerate"
  depends_on "libshout"
  depends_on "libsndfile"
  depends_on "libsoxr"
  depends_on "libvorbis"
  depends_on "libxcb"
  depends_on "libxmp"
  depends_on "mad"
  depends_on "mpg123"
  depends_on "mplayer"
  depends_on "opus"
  depends_on "opusfile"
  depends_on "projectm"
  depends_on "pulseaudio"
  depends_on "qt"
  depends_on "taglib"
  depends_on "wavpack"
  depends_on "wildmidi"

  uses_from_macos "curl"

  on_macos do
    depends_on "gettext"
    depends_on "glib"
    # musepack is not bottled on Linux
    # https://github.com/Homebrew/homebrew-core/pull/92041
    depends_on "musepack"
  end

  on_sonoma :or_newer do
    # Support Sonoma (BSD iconv) as qmmp has an incompatible typedef:
    # /tmp/qmmp-20240828-19582-sf4k85/qmmp-2.1.9/src/qmmp/qmmptextcodec.h:28:15:
    # error: typedef redefinition with different types ('void *' vs 'struct __tag_iconv_t *')
    #
    # Issue ref: https://sourceforge.net/p/qmmp-dev/tickets/1167/
    patch :DATA
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "libx11"
    depends_on "mesa"
  end

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  resource "qmmp-plugin-pack" do
    url "https://qmmp.ylsoftware.com/files/qmmp-plugin-pack/2.1/qmmp-plugin-pack-2.1.2.tar.bz2"
    sha256 "fb5b7381a7f11a31e686fb7c76213d42dfa5df1ec61ac2c7afccd8697730c84b"
  end

  def install
    cmake_args = std_cmake_args + %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DCMAKE_STAGING_PREFIX=#{prefix}
      -DUSE_SKINNED=ON
      -DUSE_ENCA=ON
      -DUSE_QMMP_DIALOG=ON
    ]
    if OS.mac?
      cmake_args << "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-undefined,dynamic_lookup"
      cmake_args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-undefined,dynamic_lookup"
      cmake_args << "-DCMAKE_MODULE_LINKER_FLAGS=-Wl,-undefined,dynamic_lookup"
    end

    system "cmake", "-S", ".", *cmake_args
    system "cmake", "--build", "."
    system "cmake", "--install", "."

    ENV.append_path "PKG_CONFIG_PATH", lib/"pkgconfig"
    resource("qmmp-plugin-pack").stage do
      system "cmake", ".", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
      system "cmake", "--build", "."
      system "cmake", "--install", "."
    end
  end

  test do
    # Set QT_QPA_PLATFORM to minimal to avoid error "qt.qpa.xcb: could not connect to display"
    ENV["QT_QPA_PLATFORM"] = "minimal" unless OS.mac?
    system bin/"qmmp", "--version"
  end
end

__END__
diff --git a/src/qmmp/qmmptextcodec.h b/src/qmmp/qmmptextcodec.h
index 5242c33..7399c54 100644
--- a/src/qmmp/qmmptextcodec.h
+++ b/src/qmmp/qmmptextcodec.h
@@ -21,12 +21,11 @@
 #ifndef QMMPTEXTCODEC_H
 #define QMMPTEXTCODEC_H

+#include <iconv.h>
 #include <QByteArray>
 #include <QStringList>
 #include "qmmp_export.h"

-typedef void *iconv_t;
-
 class QMMP_EXPORT QmmpTextCodec
 {
 public:
