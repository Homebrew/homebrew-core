class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  url "https://github.com/mltframework/mlt/releases/download/v7.2.0/mlt-7.2.0.tar.gz"
  sha256 "34b737fae61dabddf3ec64477298decb9b2076388ccbda7e50114996b268086d"
  license "LGPL-2.1-only"
  head "https://github.com/mltframework/mlt.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "83d8addf8cecf1fea2cd2e1892ff1799b57c982571e605e491e1f4a958cf05fa"
    sha256 cellar: :any, big_sur:       "a5ed8ed18a6ff72c753eb74b5c2bdb68280d33351ec3a1d35aff321f28f16c66"
    sha256 cellar: :any, catalina:      "d26f34e0a66f0ec86d0ada2c3bfe41e346623eacc39b5348c22db46b03245806"
    sha256               x86_64_linux:  "f6543f9c1652493fa4b6c68cf127dedfcccbc61dae4b1a933d343361d6467457"
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
