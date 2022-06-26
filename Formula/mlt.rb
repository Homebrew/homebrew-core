class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  url "https://github.com/mltframework/mlt/releases/download/v7.8.0/mlt-7.8.0.tar.gz"
  sha256 "4165e62e007e37d65e96517a45817517067897eedef4d83de7208dbd74b1f0f7"
  license "LGPL-2.1-only"
  head "https://github.com/mltframework/mlt.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "dcaf9747d3aad9909d225e3b98864072103d2d2b93391678ef66732ee970e8eb"
    sha256 arm64_big_sur:  "b9b6b9540a4c478a0f64612f430c821c67b2652fa483cce1f22098cb04ac4851"
    sha256 monterey:       "b6e91b91d5640a87dbe02513c88f698ca4dd35e03d3e0ba5abb67a426d224039"
    sha256 big_sur:        "c552e946cad9bb2752889885296d9983f96ab13edd609371ba766577d1e0a1bf"
    sha256 catalina:       "561db9de0a8f913913d8190071dd3f08bfc7ad7b535cd83112c258a911392ca1"
    sha256 x86_64_linux:   "59f7e0cb66e63fcd8961a22e578622f3086d5af31a6f633e370461d126ad0ba0"
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
    rpaths = [rpath]
    rpaths << "@loader_path/../../lib" if OS.mac?

    args = std_cmake_args + %W[
      -DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}
      -DGPL=ON
      -DGPL3=ON
      -DMOD_OPENCV=ON
      -DMOD_JACKRACK=OFF
      -DMOD_SDL1=OFF
      -DRELOCATABLE=OFF
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
