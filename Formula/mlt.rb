class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  url "https://github.com/mltframework/mlt/releases/download/v7.6.0/mlt-7.6.0.tar.gz"
  sha256 "49f3c7902432a5a873ebce8406d901ac73623ff3dba7265b6e8b55cfe8220201"
  license "LGPL-2.1-only"
  head "https://github.com/mltframework/mlt.git", branch: "master"

  bottle do
    sha256 arm64_big_sur: "75ebe6e53d6d94f41b774d6657a6b9e634af506a3f81222e90bf586f3d89cabf"
    sha256 big_sur:       "cdf94bf5644bad214e7002f8c58bee10076ae981b5128a8e99802a4350ee3756"
    sha256 catalina:      "9846d56f31fa1b65f4343c3ad607e19ee77e399cc018b32b337ec8167ea39f04"
    sha256 x86_64_linux:  "82a103b511b1b1b1a43f2d2d9d0df154a30d79ec60bc2317553d9bcc7999dd8a"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg@4"
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

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    rpaths = [rpath]
    rpaths << "@loader_path/../../lib" if OS.mac?

    args = std_cmake_args + %W[
      -DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}
      -DGPL=ON
      -DGPL3=ON
      -DMOD_OPENCV=ON
      -DMOD_JACKRACK=OFF
      -DMOD_SDL1=OFF
      -DRELOCATABLE=OFF
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
