class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  url "https://github.com/mltframework/mlt/releases/download/v7.24.0/mlt-7.24.0.tar.gz"
  sha256 "8cde7c22a1a5395abe913976c2edafb498f81ed81a5f49dd0e6e2d86d68bcec0"
  license "LGPL-2.1-only"
  revision 2
  head "https://github.com/mltframework/mlt.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "e059360652d0d922307d8ac9fa183322dee526d50ae1c9efe31d99e535b99d88"
    sha256 arm64_ventura:  "f1b617de121e9e9aca3ba3da5d349d5752574995c22f51e4f26e501ec91224fe"
    sha256 arm64_monterey: "76e3e6d5b1cf2a9f3005990f38f79b12948920990cdd18502079200ead1a6dec"
    sha256 sonoma:         "39fc84f9e283e7db8b2d97d3d373751ea208aa7248d71b2fb40653a9ddc7fe4c"
    sha256 ventura:        "487a3f84f939bc29c8ed2391741cee07f6c9dba31b718c701aa205526d3efad7"
    sha256 monterey:       "6458f0bcf36f5b7fecd0f089734ed49f35141ee68062b5b131d0e56a81e1fac0"
    sha256 x86_64_linux:   "fc30f4414d09163aad57fae6702b01ca86098e265c1ba437692419717ff844d5"
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
