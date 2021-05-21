class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  url "https://github.com/mltframework/mlt/releases/download/v7.0.1/mlt-7.0.1.tar.gz"
  sha256 "b68c88d9ad91889838186188cce938feee8b63e3755a3b6fb45dc9c2ae0c5ecd"
  license "LGPL-2.1-only"
  head "https://github.com/mltframework/mlt.git"

  bottle do
    sha256 big_sur:  "25813b8268445f3776c439d80edc2ef23728237978ed0823cc5b6369f45ad68b"
    sha256 catalina: "b3ee3bb7bad07c158d2cccbb5d4629489a4360a58bf0a161a1557745a43f5b57"
    sha256 mojave:   "6b9b14a33bc1022aed3c57c4553bb106c0de72190ec261cba41a3ef7b62be459"
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

  def install
    args = std_cmake_args + %W[
      -DCMAKE_INSTALL_RPATH=#{opt_lib}
      -DGPL=ON
      -DGPL3=ON
      -DMOD_OPENCV=ON
      -DMOD_JACKRACK=OFF
      -DMOD_SDL1=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Workaround as current `mlt` doesn't provide an unversioned mlt++.pc file.
    # Remove if mlt readds or all dependents (e.g. `synfig`) support versioned .pc
    (lib/"pkgconfig").install_symlink "mlt++-7.pc" => "mlt++.pc"
  end

  test do
    assert_match "help", shell_output("#{bin}/melt -help")
  end
end
