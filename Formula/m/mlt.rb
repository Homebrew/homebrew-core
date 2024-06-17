class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  url "https://github.com/mltframework/mlt/releases/download/v7.24.0/mlt-7.24.0.tar.gz"
  sha256 "8cde7c22a1a5395abe913976c2edafb498f81ed81a5f49dd0e6e2d86d68bcec0"
  license "LGPL-2.1-only"
  head "https://github.com/mltframework/mlt.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "3485b8a1722356ee8d3793d8af6a811b206d5aae8a08643b1b9fd4e65e1abf1a"
    sha256 arm64_ventura:  "c942d5f913b82087da5eccf1452543c1a9c608af92572f50e54f12590fa0a927"
    sha256 arm64_monterey: "7a98f0c4a9078c2fef892d4277055e01c48c40130cbcb540e44d5c3a92a14bca"
    sha256 sonoma:         "fa96023d1218e33b038a561781e6bbc4db1cc97428b46fb02d614c9b21698e6e"
    sha256 ventura:        "902f2db879ce420f63b623eecdfa702677c16e24ce67ed2d85b5aaba3b79fa43"
    sha256 monterey:       "3ad62a1fe23b950cfabca2075c6676e437e0ab60fadb03e93265223e3f825414"
    sha256 x86_64_linux:   "ecaa345a86798a5a5a4600807481decf70f2904502ca4ef98f41144fb373ee9c"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg@6"
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
