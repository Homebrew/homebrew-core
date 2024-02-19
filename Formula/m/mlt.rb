class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  url "https://github.com/mltframework/mlt/releases/download/v7.22.0/mlt-7.22.0.tar.gz"
  sha256 "7cf4d9573a061d76902c6e12a2f09f5f461e7c697635233df82a63a3fe4d6da6"
  license "LGPL-2.1-only"
  revision 1
  head "https://github.com/mltframework/mlt.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "b68d3e75ce464d07df784ce792a4b1705fa554329d6d2e8769612265c177122c"
    sha256 arm64_ventura:  "6dad882486d787d034595de0d1cdce9ff3e19b25c4f9cace7f881daf3fb1d738"
    sha256 arm64_monterey: "361f633a056714a0273fc7624d0354c350e58c5c0c3dc99f72003c416fc8fdb4"
    sha256 sonoma:         "34d3ec34ee74cda44f313f85547a7d2c0ecd0b44fbaa639a223acccf342b5ba0"
    sha256 ventura:        "39a6d9f6bf6970ca17fb08542c102dd7db6fb5c52960d41235e01bdc20550a31"
    sha256 monterey:       "0a7cf3cf38073a79e0f0944844efd4962592f832c5c5e1460a8c839335e5a8f6"
    sha256 x86_64_linux:   "fb50992d0ffc75c4f330ca03261c614705fb4705b89e92082740796de178654e"
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
  depends_on "qt"
  depends_on "sdl2"
  depends_on "sox"

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
