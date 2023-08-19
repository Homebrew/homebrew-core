class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  url "https://github.com/mltframework/mlt/releases/download/v7.18.0/mlt-7.18.0.tar.gz"
  sha256 "9c57da14fbf3cb9c23b867b36f038aac7978c159ba0e8d8ac90e31c66878d115"
  license "LGPL-2.1-only"
  head "https://github.com/mltframework/mlt.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "78feed922ef24c59e06468fe7f08bffe7dea562d7a6a09241c08a1b8e695fe6b"
    sha256 arm64_monterey: "279e74b53e6bad52b9bfc7363abb8fc39e0b3b04dec03bcec2f1835ed8b13585"
    sha256 arm64_big_sur:  "c539a434d819e5e55747d91c4064b512358779518c23fdbbf70bc2088af7827e"
    sha256 ventura:        "581f9530663ded632181c214f65444be23f821add9f0b2e2486b947642eae7e2"
    sha256 monterey:       "59e130bb66ca2b5542fb5230cd151af276f6e34538f6262ce919431ab742322f"
    sha256 big_sur:        "9cb541e5964e58f4d881ae53a9ff4be4e4038b0284b862ce5090dbeb96873381"
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
