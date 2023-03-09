class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  url "https://github.com/mltframework/mlt/releases/download/v7.14.0/mlt-7.14.0.tar.gz"
  sha256 "3a7e83ed5e30f3f2d073d172c9d886310d8a73dbd2ee850ad44e3c43a9ab6394"
  license "LGPL-2.1-only"
  revision 1
  head "https://github.com/mltframework/mlt.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "92560cef932c9e3294ce58ffdce1d8c7f16c2a10f0c1c08746eb597ba8c06848"
    sha256 arm64_monterey: "fcc29906dde39a762a1052504f13088b4254ec69bed0aef64d65acf9d2e7a997"
    sha256 arm64_big_sur:  "9a08c0e5de4f67e8cc0bf25596fbfd05d7e53c1703e4b320fa49ae576fb8ba43"
    sha256 ventura:        "68e8b2ee332e028f14e5ebaec082372c2687e296d142336252d5bf9cda10e8d9"
    sha256 monterey:       "d98e2c1f1b8b8e9adfb220a4f7ecd396069a00947b78bace7eb6f89c5e1d2445"
    sha256 big_sur:        "207b683aff7cea1b4cf6cb68e5d8f511c1b16598f9021a2aa98d055762b9b2f7"
    sha256 x86_64_linux:   "84ac7a4eae7135bd36cdccf73c7bbc077ea099ca8473661977b6abec3c5904cb"
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
