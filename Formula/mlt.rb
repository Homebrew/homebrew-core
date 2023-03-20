class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  url "https://github.com/mltframework/mlt/releases/download/v7.14.0/mlt-7.14.0.tar.gz"
  sha256 "3a7e83ed5e30f3f2d073d172c9d886310d8a73dbd2ee850ad44e3c43a9ab6394"
  license "LGPL-2.1-only"
  revision 1
  head "https://github.com/mltframework/mlt.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "622f966bba54062cf0ec3e6234ed883e81407cd6d4c05ab86810e03e350fdde9"
    sha256 arm64_monterey: "5b73f696beef197a68da2d2d78402c0cdc9e5ea5bcf61814ab968c5d2dae6247"
    sha256 arm64_big_sur:  "0e33c8fed4caa646c9bcaae1a8d1ea7e3f4c500d3b53fd2a25b503c2a017043f"
    sha256 ventura:        "39ca648d207d732c1b328df99599054ef1b8368c4ccaa9633d431992e3ec83cb"
    sha256 monterey:       "becca4a14249ad1449c13deb49fcdce6a26c3fe5b8ce30cd05fb4cfdcf11388b"
    sha256 big_sur:        "089eecb283c2f533c027c51a785a059eac8b936a457d2e0f7645de0aac716471"
    sha256 x86_64_linux:   "256b00f55279c111b0807eb081af2d9b235eddcc0bbea9de71aee754a322c9a8"
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
