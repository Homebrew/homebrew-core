class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_2.0.3.tar.gz"
  sha256 "b1f65aba4aa76bdf6da1ad923018de6844f5b76f9974978b4b12be108f87261e"
  head "https://github.com/dtschump/gmic.git"

  bottle do
    cellar :any
    sha256 "d4c4d6aa0b632a59c3b820fb5500829cd23d412f51278cf841724972c5a6acfd" => :sierra
    sha256 "4f3b362c9ee3ca9ecbe97e984330a97ba4b8b205893a2300e7023eddf7d6d0e2" => :el_capitan
    sha256 "c58b0a30ab3040656a3c84b17588e8952d5df7fdfdf02039f161f57dc589af3f" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "jpeg" => :recommended
  depends_on "libpng" => :recommended
  depends_on "fftw" => :recommended
  depends_on "opencv@2" => :optional
  depends_on "ffmpeg" => :optional
  depends_on "libtiff" => :optional
  depends_on "openexr" => :optional

  def install
    cp "resources/CMakeLists.txt", buildpath
    args = std_cmake_args
    args << "-DENABLE_X=OFF"
    args << "-DENABLE_JPEG=OFF" if build.without? "jpeg"
    args << "-DENABLE_PNG=OFF" if build.without? "libpng"
    args << "-DENABLE_FFTW=OFF" if build.without? "fftw"
    args << "-DENABLE_OPENCV=OFF" if build.without? "opencv"
    args << "-DENABLE_FFMPEG=OFF" if build.without? "ffmpeg"
    args << "-DENABLE_TIFF=OFF" if build.without? "libtiff"
    args << "-DENABLE_OPENEXR=OFF" if build.without? "openexr"
    system "cmake", *args
    system "make", "install"
  end

  test do
    %w[test.jpg test.png].each do |file|
      system bin/"gmic", test_fixtures(file)
    end
  end
end
