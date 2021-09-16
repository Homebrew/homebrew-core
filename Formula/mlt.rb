class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  url "https://github.com/mltframework/mlt/releases/download/v7.4.0/mlt-7.4.0.tar.gz"
  sha256 "17c19843ffdbca66777aaadf39acb11829fd930eaded92f768cbcb8ae59a5f37"
  license "LGPL-2.1-only"
  revision 1
  head "https://github.com/mltframework/mlt.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "6dd1974dc373071adc0a5292fe058b12a9a3b2b0a1de15364c671ae5eb027792"
    sha256 cellar: :any, big_sur:       "ba186fcdc0edc6829c1bfe290778081336867956733645f1f90814dd474f3c88"
    sha256 cellar: :any, catalina:      "3b14fac2336bd4e496f027cb3032068a9eda0acb64ad21a7eff68699b9b01579"
    sha256               x86_64_linux:  "4ae090584acf76fa32e611c71cff0cf2ab8bd671c99e2fd0a4cf090b9735dd0c"
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
