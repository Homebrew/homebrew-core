class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  url "https://github.com/mltframework/mlt/releases/download/v7.14.0/mlt-7.14.0.tar.gz"
  sha256 "3a7e83ed5e30f3f2d073d172c9d886310d8a73dbd2ee850ad44e3c43a9ab6394"
  license "LGPL-2.1-only"
  head "https://github.com/mltframework/mlt.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "2c4651f63550c5c19bfac52e73a2e1d7a19856cfe1fd3da9ca030175d08f9d87"
    sha256 arm64_monterey: "1de7a585b4b194ae22c0e9cfe63138c7ea259004c5fd614db4d43827329e75f9"
    sha256 arm64_big_sur:  "c199677b5ff1ce8d2bddb419d2e737cf73a5c5ab8acfe6ceb338a2f6482a8c37"
    sha256 ventura:        "2fbcb49848d82667ce73e3c1eb682d4479f8ed1d0f1b45108d5bc0c197e9d8d1"
    sha256 monterey:       "3bbb6451dd55a7f13d51a2b3cdcb202676f67c93f12c717c0b64de0b0d26e12a"
    sha256 big_sur:        "0d28fd842a31c83afbc4c2b146f1f3e29b708f0b5a4bc405b6d021cc951bd309"
    sha256 x86_64_linux:   "c35b40e1e63c5c1c5a88fe9db561e5693509cabc36b1629f55ed9c80f2403b88"
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
