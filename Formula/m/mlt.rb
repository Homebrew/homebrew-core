class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  url "https://github.com/mltframework/mlt/releases/download/v7.34.1/mlt-7.34.1.tar.gz"
  sha256 "4104b87db3e14389f81666938c131f723564773fec9aa18b6bff008761cc838b"
  license "LGPL-2.1-only"
  head "https://github.com/mltframework/mlt.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "22a8292716eb5104a09b7a55e40fad6b0a30417bbc1df32c7b5fbf8c9e1aef3d"
    sha256 arm64_sequoia: "af25732dc924762956280f5a8126a6582db616317d7c18c8086e7d80a2f881e5"
    sha256 arm64_sonoma:  "ea71492bcb2a5297fe5a8061b5fba2d7176b4daafa17d6e0bfd74de463c83f82"
    sha256 sonoma:        "dff42b3a260f17aff918ec45da4813f6e77bea4e8937ad8f8b1147ba135db6ff"
    sha256 arm64_linux:   "26f3e2daf30fa5e45a08a2de948d41e3bea526f5e8438ce568e140f8114ead00"
    sha256 x86_64_linux:  "0931d5ab6fe3bd86afd464fb845d4e1e88b0582d35208220c5659982ab645a69"
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
                    "-DMOD_MOVIT=OFF",
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
