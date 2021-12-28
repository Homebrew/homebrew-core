class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  url "https://github.com/mltframework/mlt/releases/download/v7.4.0/mlt-7.4.0.tar.gz"
  sha256 "17c19843ffdbca66777aaadf39acb11829fd930eaded92f768cbcb8ae59a5f37"
  license "LGPL-2.1-only"
  revision 3
  head "https://github.com/mltframework/mlt.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "90da35634d99fdc9d29eb921e13d444f0fe9a3ced4ba2e83a2b3378c3cb67f8a"
    sha256 cellar: :any, big_sur:       "aa8ecfb467b2d2d0963c95a62008b24c91b285319a44c245aef6c91edd0b57bd"
    sha256 cellar: :any, catalina:      "930332fecb1ad269581a75f17a89bd3e56ebe2ca1c705a4342d1293bbd8a330a"
    sha256               x86_64_linux:  "c5d66c6b67a37304ebe7ded0bc6d4b4867fbd32b1ee0213fe7f62b7ce2cb0b9d"
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
