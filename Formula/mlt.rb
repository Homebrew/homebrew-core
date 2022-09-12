class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  url "https://github.com/mltframework/mlt/releases/download/v7.8.0/mlt-7.8.0.tar.gz"
  sha256 "66606d79f91b400a4d9380a911a5d771a48bd6413447fa2f3713459eba70242d"
  license "LGPL-2.1-only"
  revision 1
  head "https://github.com/mltframework/mlt.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "8bb4eba794b94fb65abfa87a053c6ff5ed62d0fa055591a5107d976ceba20759"
    sha256 arm64_big_sur:  "c093eede0d92f63e5730e7412ce860d909734f0fd2266839c8aff299dd92d0c5"
    sha256 monterey:       "0a82525c05654c1c0f83fc612a05e3764e108204d069d909f2ef4ed6b1a86ce5"
    sha256 big_sur:        "bf5d2d5b61b8e9619f4b92f622d0b5861e6188580eb0004b9e0342c670757607"
    sha256 catalina:       "f8998f3b0d01afc3ab67fbfa65ecfc1a2ea5f843d1b393c6914ef1ba32ebd6af"
    sha256 x86_64_linux:   "d68540fe7c7ebdb3fca1d7f0f6f7f90930c0ec1301ab00810ac61e248cdf22c4"
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
