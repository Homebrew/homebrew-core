class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  url "https://github.com/mltframework/mlt/releases/download/v7.40.0/mlt-7.40.0.tar.gz"
  sha256 "f11c30e21670f62a3dfc56a31306ac02f3feea00908a2821a4a0bf3e989d3d6a"
  license "LGPL-2.1-only"
  revision 2
  head "https://github.com/mltframework/mlt.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "de84a17457c3fe52588cf4ec306cc75d1a1b1ed769acbeb64b9551d05d91feb8"
    sha256 arm64_sequoia: "bf6942edd42c50934c82e32a846f567252f18828b8e2a2cdb7c55ee96c939795"
    sha256 arm64_sonoma:  "7882bc987e09701d3706405750a02aab0f74a78928672d0a5ff8746ba253cfb8"
    sha256 sonoma:        "f66603b9b100c0778993c49ea6bc5b7af49d9a6fc8c3f6f18892ea2727e756b4"
    sha256 arm64_linux:   "a50204956044e9e5a73d78725c9de4adb34b1352ff1013cd455e6a39115b27fb"
    sha256 x86_64_linux:  "3b8aae840653ec2f374865804b64ecd40b090715ff888b689f38494f73fdd9de"
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

  # Fix builds with FFmpeg 9. Remove with the next release.
  patch do
    url "https://github.com/mltframework/mlt/commit/68bceba12a3c3278ce69033c3e7dadaa13d45811.patch?full_index=1"
    sha256 "a2e7acbb2c3b585a36ae5fcddada634220c8bb30ebb75922958b5b7b30d49f96"
    type :backport
    resolves "https://github.com/mltframework/mlt/pull/1281"
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
