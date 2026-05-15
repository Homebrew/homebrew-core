class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  url "https://github.com/mltframework/mlt/releases/download/v7.38.0/mlt-7.38.0.tar.gz"
  sha256 "b8f0a23c89e9250edc5038d745537c382367bf2ad3dad5d5c7cd13b0fe1c4144"
  license "LGPL-2.1-only"
  head "https://github.com/mltframework/mlt.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "d0d8cdc099296f231676fe28f13b5fcd0b6428e09aed6bb0cbb0dbfefab44edc"
    sha256 arm64_sequoia: "fd830c5b8d17a78cc6786ded35b36bd7f644ea15782bec8d3d785aa94695ea24"
    sha256 arm64_sonoma:  "8dc4129a794787deee30182412f18e43f15df46d232f0053ecf5dc6f769e3cb4"
    sha256 sonoma:        "a2d6002992efc17a5ca53bfd219c7645189269ee0cced1c0f33da433bc6b85c5"
    sha256 arm64_linux:   "3f584f88115f90ca62c6c67252aa51e12ba1b0123dba520c69e633177f7091d9"
    sha256 x86_64_linux:  "3fab7905fc5fb4ff025f2a3cde2bb9100a7741f1f24eda53ab75b44e71909294"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "ffmpeg"
  depends_on "fftw"
  depends_on "fontconfig"
  depends_on "frei0r"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "libdv"
  depends_on "libexif"
  depends_on "libomp"
  depends_on "libsamplerate"
  depends_on "libvidstab"
  depends_on "libvorbis"
  depends_on "opencv"
  depends_on "pango"
  depends_on "qt5compat"
  depends_on "qtbase"
  depends_on "qtsvg"
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
                    "-DMOD_MOVIT=OFF",
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
