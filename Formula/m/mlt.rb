class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  url "https://github.com/mltframework/mlt/releases/download/v7.20.0/mlt-7.20.0.tar.gz"
  sha256 "7472372b31f76b2eb0ac66c756391be7cb859a3a779c97ccb7dcf7086ac9d816"
  license "LGPL-2.1-only"
  head "https://github.com/mltframework/mlt.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "9670b42ea7651685b0c031583bc5c667346d4f4fe6e1d831063e1f2611129349"
    sha256 arm64_ventura:  "00b18c247272bc344ae719dc86546930bbbd406f3877d4556f0609ef588086cd"
    sha256 arm64_monterey: "14f9ba4644bb93f548b57bcfcec89c6d20c1e69ac803cb0765aba2f3b49c3780"
    sha256 sonoma:         "f487696f45a50fb33d05ad34202f42aeb2b9a40e2d19194167bec071070d2068"
    sha256 ventura:        "a5598fa8ba7af371b1f26f9094cf4425558dcaadd842fd8af710b40fa10e9ba0"
    sha256 monterey:       "f5b5c8927074069b39f3e557e32d183c3659687380e87c390f01e19630463535"
    sha256 x86_64_linux:   "febb8a904cff64ced7eea55369d1721d0a5a54ab019c548cf98ab2e6c52377b3"
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
  depends_on "qt"
  depends_on "sdl2"
  depends_on "sox"

  fails_with gcc: "5"

  def install
    rpaths = [rpath, rpath(source: lib/"mlt")]

    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}",
                    "-DGPL=ON",
                    "-DGPL3=ON",
                    "-DMOD_JACKRACK=OFF",
                    "-DMOD_OPENCV=ON",
                    "-DMOD_QT5=OFF",
                    "-DMOD_QT6=ON",
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
