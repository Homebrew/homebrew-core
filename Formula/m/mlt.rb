class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  url "https://github.com/mltframework/mlt/releases/download/v7.40.0/mlt-7.40.0.tar.gz"
  sha256 "f11c30e21670f62a3dfc56a31306ac02f3feea00908a2821a4a0bf3e989d3d6a"
  license "LGPL-2.1-only"
  revision 2
  head "https://github.com/mltframework/mlt.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "da7b97a9f64c6d6106cbd82ae611ba51bdc5ee072031f19dac6dfe8fb16d6f74"
    sha256 arm64_sequoia: "35b0784f25599dac56ec438093aa3876617104c3bdbdd44c3e55aadbf84a18c4"
    sha256 arm64_sonoma:  "2fb1066b94087ba9369d64710c1c014bf8f0bf38b345dfa109c27d3a0fb3b6a7"
    sha256 sonoma:        "b40e167e1035ef9157794e90a7ffbf54aabf4e16d047bc6ff94724e859ffac22"
    sha256 arm64_linux:   "1a3f61c4bd14c1af14057de48edd773ad7becb055da316d0bafecc0991e0602d"
    sha256 x86_64_linux:  "8aaa1d6afd45f7259db3a639870c0b7eaade242227f96e418d55f0c65de69ebb"
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
  depends_on "sdl2-compat"
  depends_on "sox"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "freetype"
    depends_on "gettext"
    depends_on "harfbuzz"
    depends_on "libomp"
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
