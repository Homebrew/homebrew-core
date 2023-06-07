class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  url "https://github.com/mltframework/mlt/releases/download/v7.16.0/mlt-7.16.0.tar.gz"
  sha256 "c0975e06403d3df22be7d4b5d96d0608e0d16470299360d0a0ee5f41ba2b7a96"
  license "LGPL-2.1-only"
  head "https://github.com/mltframework/mlt.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "a30b5c8314f327372fd9419819bb02702b2852b7ff103b260a0afa008d182c4a"
    sha256 arm64_monterey: "69e5c658268dd8ad7f09c0a97e7b6d48c23be98521fd09c0d6c6e32135ecf185"
    sha256 arm64_big_sur:  "7bf803fbedc0be3db5aa17ddd56c469daad2ebf401a6da9ba86e04c56a848e2a"
    sha256 ventura:        "3824cad0181bf49485bc70018eca391d5cd8cfbcc6645e52c84c71fd7a402594"
    sha256 monterey:       "f2ad6cf9613fa45ed4ea741fe04fb3cd2caa4f511667ab4a1151ae849aa86b52"
    sha256 big_sur:        "0f0d1c52d99363cadf121e50a3ae31cb216a1e6d2fdf4fada333097ca2f6bd7a"
    sha256 x86_64_linux:   "c87dd9d97e1a445931024352e6f5098c04ee6e4e69b2006ed09cfdcc9cfb48e9"
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
