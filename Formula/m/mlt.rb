class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  url "https://github.com/mltframework/mlt/releases/download/v7.28.0/mlt-7.28.0.tar.gz"
  sha256 "bc425bf9602213f5f4855b78cfbbcd43eeb78097c508588bde44415963955aa1"
  license "LGPL-2.1-only"
  head "https://github.com/mltframework/mlt.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "5fdf077b8f22a6504af534516cc3e4fff6ce9cfe2bc2bd24fcd022fd6ecda08b"
    sha256 arm64_ventura:  "4b23883a06273748bdd195e6d79ed57bdc6442ef00aaba81014de46f4c4fd036"
    sha256 arm64_monterey: "a2151d1e9b01de46825920802c7d69cde820ab277d8b5714f439f8f8a4e7ece5"
    sha256 sonoma:         "6db195573da77805d7162a9c496e36241ba9e6261e670adc0dc8445b14c84d27"
    sha256 ventura:        "1c77b4fce2d5bd9e570a14559b466fdc74beae0e00e7407731787f5957ae448c"
    sha256 monterey:       "cfec4b04ec534a31c694ab6d50789614f18d05c5678082ad7ca2145f6f4431f8"
    sha256 x86_64_linux:   "190642ee62312b496773bb7b4b65caf8d34bd24cd608ee929110adf28c1c66c3"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  depends_on "ffmpeg"
  depends_on "fftw"
  depends_on "fontconfig"
  depends_on "frei0r"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "libdv"
  depends_on "libexif"
  depends_on "libsamplerate"
  depends_on "libvidstab"
  depends_on "libvorbis"
  depends_on "opencv"
  depends_on "pango"
  depends_on "qt"
  depends_on "rubberband"
  depends_on "sdl2"
  depends_on "sox"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "freetype"
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "pulseaudio"
  end

  fails_with gcc: "5"

  def install
    rpaths = [rpath, rpath(source: lib/"mlt")]

    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}",
                    "-DGPL=ON",
                    "-DGPL3=ON",
                    "-DMOD_JACKRACK=OFF",
                    "-DMOD_OPENCV=ON",
                    "-DMOD_QT5=OFF",
                    "-DMOD_QT6=ON",
                    "-DMOD_SDL1=OFF",
                    "-DRELOCATABLE=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Workaround as current `mlt` doesn't provide an unversioned mlt++.pc file.
    # Remove if mlt readds or all dependents (e.g. `synfig`) support versioned .pc
    (lib/"pkgconfig").install_symlink "mlt++-#{version.major}.pc" => "mlt++.pc"
  end

  test do
    assert_match "help", shell_output("#{bin}/melt -help")
  end
end
