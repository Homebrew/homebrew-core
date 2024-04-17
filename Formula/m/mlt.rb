class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  url "https://github.com/mltframework/mlt/releases/download/v7.22.0/mlt-7.22.0.tar.gz"
  sha256 "7cf4d9573a061d76902c6e12a2f09f5f461e7c697635233df82a63a3fe4d6da6"
  license "LGPL-2.1-only"
  revision 2
  head "https://github.com/mltframework/mlt.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "1c50afea5caf1a7c36d103daa13d506c8980868df221d4d5bf31e9d9799e5935"
    sha256 arm64_ventura:  "7cd71f648f6ac36803db3a470c73bca56c437b36bd9e5f2cbd4d611b4feaf5ed"
    sha256 arm64_monterey: "44e866c91e3e455c3f8176a9ec2d5dc6e7dd0f11421a80fc96455d7e41e64241"
    sha256 sonoma:         "7b37b96ea91ee8566fc3d42cff867a96d082408a53701278a418dc3df56d5770"
    sha256 ventura:        "2ef37b0f8aca9e14bcf72d519ceb61e8c800f8d10c247855db2b572311f26b4e"
    sha256 monterey:       "e1b6f180be87c8ebd89b4aa3f1902d1e7faf19e4aa41276f8aa2e83bb87687c1"
    sha256 x86_64_linux:   "e51b56206214e1e4dd1375fb4d8cdd46a82ff8e8870d58f5ceb31115b99261c3"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg@6"
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
