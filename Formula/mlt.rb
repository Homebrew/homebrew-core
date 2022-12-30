class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  url "https://github.com/mltframework/mlt/releases/download/v7.12.0/mlt-7.12.0.tar.gz"
  sha256 "48b385e83cbd5bf68bfc88631273868fbee36a41b3b7e2acd97f12b095b0083c"
  license "LGPL-2.1-only"
  revision 1
  head "https://github.com/mltframework/mlt.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "327e2eced3732e4feaf7c233e130cc30cdf08e032c299495dc3b539d025acfc4"
    sha256 arm64_monterey: "ae182e813b36c3da6c381986b46136c63732821e9090ee6c7c8705cf3e91da4d"
    sha256 arm64_big_sur:  "9eb8be2a22ac2d125f70abe68fb0c19b3edc9c78380aaac094fd4da179d906ba"
    sha256 ventura:        "429bbdfc1eef1eeb8a31639af2b94f6daa9be1470e8e4f12dbc510558554a93f"
    sha256 monterey:       "6cebbf6fc0e682c0db2781b4c938a0bc9efc7dac64f5abeaa36859c01907ae0c"
    sha256 big_sur:        "8e4096acbba93e64d3f37db56408e6672eb8fdda87f109fee2347111b1ae38ba"
    sha256 catalina:       "f46b832131ee0af2ffedfa568da4d285efb458dce6ffa94938cbca5d51e5da7a"
    sha256 x86_64_linux:   "92cbc29cdb8b00f26a17654db6fa2cf2723691bbbfc6f678feac86deaffdb19f"
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
