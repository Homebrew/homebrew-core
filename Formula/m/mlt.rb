class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  url "https://github.com/mltframework/mlt/releases/download/v7.40.0/mlt-7.40.0.tar.gz"
  sha256 "f11c30e21670f62a3dfc56a31306ac02f3feea00908a2821a4a0bf3e989d3d6a"
  license "LGPL-2.1-only"
  revision 1
  head "https://github.com/mltframework/mlt.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "0463ca39d1781d3c4cf201b56f1a2aa752c9677d1a398f0d66a1d4aab58afcbc"
    sha256 arm64_sequoia: "f59881c75605c6a3fa05e64425312d0063e42430516f5e01094e40284ef61035"
    sha256 arm64_sonoma:  "4837c3f75837874f357ac63855224405bd8deaaa8d35fdfcb313c1b15cacf343"
    sha256 sonoma:        "011a7cc1d534bbfd8a028f8e789afd6b1629055fed144ab9d991fd2f6755373d"
    sha256 arm64_linux:   "e80678a264238f4c4ca87fc11aae069b49b8e016f2e0d9b92f527c6a74a3d478"
    sha256 x86_64_linux:  "1e2cd9aa006a5ce5ddde467e5716b705cee8de6d6188a56272a807056fb19a3b"
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
  depends_on "sdl2-compat"
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
                    "-DMOD_RNNOISE=OFF",
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
