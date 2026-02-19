class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  url "https://github.com/mltframework/mlt/releases/download/v7.36.1/mlt-7.36.1.tar.gz"
  sha256 "0d2b956864ba2ff58bb4e2b2779aa36870bd2a3a835e2dbfda33faa5fc6f4d3a"
  license "LGPL-2.1-only"
  revision 1
  head "https://github.com/mltframework/mlt.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "81cd06d782ba666f6a319ccd94bf54a61e7278433f721fea45a8aa07f36d386e"
    sha256 arm64_sequoia: "1a9cf323f3916df0985fc36b579784b67ab0217a9d69f836f30c206538ebf3d7"
    sha256 arm64_sonoma:  "8b9bdef7c268fc5387dc7803c4d4110c793d7a7ddf76e17ab3f5405c71aa7aed"
    sha256 sonoma:        "e5c7487a7d1dc5c58cebdabacdcfa41c3818692aa89453ddc0f09bbcef9cb467"
    sha256 arm64_linux:   "95761fd2e2174018ba5b50ae8b295d6147317a8a28ffd3155f6f5c84bb2b7de1"
    sha256 x86_64_linux:  "752b678fe0290dcef506287baae7f4882c674c10f70bf7cd6a5bf96233792ba4"
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
