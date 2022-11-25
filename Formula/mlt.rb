class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  url "https://github.com/mltframework/mlt/releases/download/v7.12.0/mlt-7.12.0.tar.gz"
  sha256 "48b385e83cbd5bf68bfc88631273868fbee36a41b3b7e2acd97f12b095b0083c"
  license "LGPL-2.1-only"
  head "https://github.com/mltframework/mlt.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "86ba8d92a6b31503619e1ea8d32ecb04c3ea385606497d1007337cdb7ac7b5ca"
    sha256 arm64_big_sur:  "4a33637cfd6f5b5c733e7e91f28b540475bdeaa7e16acf7516af492647d227a2"
    sha256 monterey:       "ba2783e49b12f9d25c873fda81f1405653ea7bedc17f87abadfa9e5b34c0a368"
    sha256 big_sur:        "cb2305613a3c3cc80b53069438548643f559318977ff9222d3e9fe6ea5351556"
    sha256 catalina:       "27708e2afef1b745a5bc0a85f01090a4634f44091d8179d58b45748122ab1449"
    sha256 x86_64_linux:   "3f8605e95c43f460c753bf944deb8e4661a80528e0b907f3700f871827d4e188"
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
