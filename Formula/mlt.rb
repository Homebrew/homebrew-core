class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  url "https://github.com/mltframework/mlt/releases/download/v7.8.0/mlt-7.8.0.tar.gz"
  sha256 "66606d79f91b400a4d9380a911a5d771a48bd6413447fa2f3713459eba70242d"
  license "LGPL-2.1-only"
  revision 1
  head "https://github.com/mltframework/mlt.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_monterey: "2998ab596ce39b9e2765b169f6f49dc7ef73301988c1952b90bb1a17f701b8f7"
    sha256 arm64_big_sur:  "20e65cade5bc4f2e6f58e5f343714892afa178ba5769097c01da59d719404d02"
    sha256 monterey:       "56cbb917dfc78d1308a37a713aaa0fbe9085288b785c2bbb39bee04041cadeb6"
    sha256 big_sur:        "c666d926739e0be20b42208a458472598137e14584fc6bc6b05a3db29e339f9c"
    sha256 catalina:       "26959c80f7495223c31a3e607d95d09fd9c49ffd9c62be2c7d83f069c78cf96d"
    sha256 x86_64_linux:   "9c8882eb8158298e2db065bd9f9b3f0857b499cfd7ced285955787059e68b808"
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
