class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  url "https://github.com/mltframework/mlt/releases/download/v7.0.1/mlt-7.0.1.tar.gz"
  sha256 "b68c88d9ad91889838186188cce938feee8b63e3755a3b6fb45dc9c2ae0c5ecd"
  license "LGPL-2.1-only"
  head "https://github.com/mltframework/mlt.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "d00252804029df19b594f3f50c08349fa31b1d845224b21def935e0366de99cc"
    sha256 cellar: :any, big_sur:       "e7301086e4ea074fc89d486c097a9199a4a6a5a0fb026729dd07f23a362ff134"
    sha256 cellar: :any, catalina:      "9fee3844b1061d73a16c713abda9f598ad68b69dc9425b82e9a1ee9a2737103a"
    sha256 cellar: :any, mojave:        "bb5e8a1b1f218ef5bdf899ee18023014ceecf9d9b360668f9fab2f1d15c49936"
    sha256               x86_64_linux:  "5f5a888250ab01dddbb4742fa00c32dbb889d46b17dc050883db107d8817c57c"
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
