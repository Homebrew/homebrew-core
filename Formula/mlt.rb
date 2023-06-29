class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  url "https://github.com/mltframework/mlt/releases/download/v7.16.0/mlt-7.16.0.tar.gz"
  sha256 "c0975e06403d3df22be7d4b5d96d0608e0d16470299360d0a0ee5f41ba2b7a96"
  license "LGPL-2.1-only"
  revision 1
  head "https://github.com/mltframework/mlt.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "118dae1548b288b0bad5ea9b4701de1cee22b72373e403365dd0d1c8e1886583"
    sha256 arm64_monterey: "51aae9bca7b91cae08d08bc5879340f94d36e69c296f9abbe2bc6e66bb3a2034"
    sha256 arm64_big_sur:  "0ad06b0d804169e17777ad867d4962b1f06371b35e9b146c7a4c5eb7ee54ce7d"
    sha256 ventura:        "f409602e9472dce1923de59f01b966179131e04777048d72c0853185ea2688af"
    sha256 monterey:       "1511b0808f66678db8178e21f696a8f3ec164132a0e76c8faa7b970edb12223c"
    sha256 big_sur:        "7df0b057389444d7ea4cb4d980c2c74485701eccf3e88a9d4a2f7aa9137c8ff3"
    sha256 x86_64_linux:   "caff39fcd5779340a01d250f639f07cca945e4ba0b963811a1e1d780f3d8a492"
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
