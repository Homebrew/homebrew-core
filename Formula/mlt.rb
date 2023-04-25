class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  url "https://github.com/mltframework/mlt/releases/download/v7.14.0/mlt-7.14.0.tar.gz"
  sha256 "3a7e83ed5e30f3f2d073d172c9d886310d8a73dbd2ee850ad44e3c43a9ab6394"
  license "LGPL-2.1-only"
  revision 2
  head "https://github.com/mltframework/mlt.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "fad91a1f3ee0e3ed76021731be3eb7d43b2c2e7c1bb6afa49d601f8e9da411f0"
    sha256 arm64_monterey: "40669c61cf7cd3c67a2d690208c88227a0672178ae898e032dfa3b8fe2d0ff82"
    sha256 arm64_big_sur:  "516631286ca3a1310e7e3e61d44ee3577696890f724438cb9b6406606ad459bb"
    sha256 ventura:        "2d3a12647f150192f36da6656c5eb23785ba27a20dc61951eaa49052ef1470f6"
    sha256 monterey:       "4a9b5cfc3ab796b9a091da1753309cf0e5fc32001deadc5ac3a6ec879f549f76"
    sha256 big_sur:        "1971e096f15e177160ee0d4498192782b90b842fed5a511ecbd826f004148806"
    sha256 x86_64_linux:   "a75b1a60c012a46b624074332c5a9cd267638d5ee2cf95a52f8f896112564c19"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "fftw"
  depends_on "frei0r"
  depends_on "gdk-pixbuf"
  depends_on "libdv"
  depends_on "libexif"
  depends_on "libsamplerate"
  depends_on "libvorbis"
  depends_on "opencv"
  depends_on "pango"
  depends_on "qt@5"
  depends_on "sdl2"
  depends_on "sox"

  fails_with gcc: "5"

  def install
    rpaths = [rpath, rpath(source: lib/"mlt")]

    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}",
                    "-DGPL=ON",
                    "-DGPL3=ON",
                    "-DMOD_OPENCV=ON",
                    "-DMOD_JACKRACK=OFF",
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
