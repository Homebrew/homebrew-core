class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  url "https://github.com/mltframework/mlt/releases/download/v7.34.0/mlt-7.34.0.tar.gz"
  sha256 "17278c650ea223127c3207de9bbf0364e0771699930716901071508d80b256b1"
  license "LGPL-2.1-only"
  head "https://github.com/mltframework/mlt.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "f3a15d4cbab669ba7e63aadca1acd6a93ea43d92f7001bb61f70b6592b611867"
    sha256 arm64_sequoia: "a6e2b4608def05c0b65c582c3c91424db5fbcdc66cdfc234f7851aed43e2cfa5"
    sha256 arm64_sonoma:  "b147a6c2b447e5f492378f852825fd3ccc6daba38ff9e4ce9d45e1c7b253b8af"
    sha256 sonoma:        "b3978daa88aac4c0af94d25ad45df803671668c911c773388be602090ee23304"
    sha256 arm64_linux:   "9263ef1a153c7fe204b435507624b5f862bc4a6b9d2cac10187089374be97d2e"
    sha256 x86_64_linux:  "06fad8eb1fdfc8ab37ad5624a3f19499a32beccae2f156e63c862b7c61b7cde4"
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
