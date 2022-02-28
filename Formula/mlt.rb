class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  url "https://github.com/mltframework/mlt/releases/download/v7.4.0/mlt-7.4.0.tar.gz"
  sha256 "17c19843ffdbca66777aaadf39acb11829fd930eaded92f768cbcb8ae59a5f37"
  license "LGPL-2.1-only"
  revision 3
  head "https://github.com/mltframework/mlt.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "a0c0dd611fb0ab03c02c96979255acd569fb77984aa19486e169cb5375ffc221"
    sha256 cellar: :any, big_sur:       "b2e7e2107aec1cbf470030fdc8609713dda27559c4f0fde868793b992213f132"
    sha256 cellar: :any, catalina:      "d3ee23e4d6e421c3266411dccd20d2f04ecd21594951e36c8cbadc1850b115b4"
    sha256               x86_64_linux:  "03ea590c7009f352ab684bbab364a04201e99ce353709c1f39e78a91fd28607a"
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
