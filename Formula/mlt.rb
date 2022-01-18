class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  url "https://github.com/mltframework/mlt/releases/download/v7.4.0/mlt-7.4.0.tar.gz"
  sha256 "17c19843ffdbca66777aaadf39acb11829fd930eaded92f768cbcb8ae59a5f37"
  license "LGPL-2.1-only"
  revision 2
  head "https://github.com/mltframework/mlt.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "f0d9cdc18a2042e0daf930365433c2d74b5681aee8aedc630ad140831a525412"
    sha256 cellar: :any, big_sur:       "6d09f4024c6965213755fa7f160e4e75c7c87e2cd22b9c09c9b616bae34ec77e"
    sha256 cellar: :any, catalina:      "4875ea63b7f964a167852f5156a3ebf79c1350c1660f728ad3d30debee1ab9e4"
    sha256               x86_64_linux:  "48fa59c80d2c1b6002dcaf1bf365a1a7943ff8d870b34efa7f6fb0628747f489"
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
