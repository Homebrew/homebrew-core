class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  url "https://github.com/mltframework/mlt/releases/download/v7.6.0/mlt-7.6.0.tar.gz"
  sha256 "49f3c7902432a5a873ebce8406d901ac73623ff3dba7265b6e8b55cfe8220201"
  license "LGPL-2.1-only"
  head "https://github.com/mltframework/mlt.git", branch: "master"

  bottle do
    sha256 arm64_big_sur: "134fce14fc1a84429b9612ea8de0efeee380ce553025682e0c63e02a1f239b1a"
    sha256 big_sur:       "efe2661c2906b0a9d3c50f9d79c3b03f174ce93a68bcf731fbc8210092d46656"
    sha256 catalina:      "12d78ae602fef7cfdd2ac81c9daa2156f912dc52be9a492f1c63502cdee3c8e1"
    sha256 x86_64_linux:  "4701398d6369a88c79790db45992a4259eee83e41f040eef14523d2642cda485"
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
