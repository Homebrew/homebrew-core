class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_2.1.3.tar.gz"
  sha256 "c0b82ecc9d2b86ba0f62622094ef671857e32830b913ee3a5db4efdfae071e49"
  head "https://github.com/dtschump/gmic.git"

  bottle do
    cellar :any
    sha256 "86926c82431646ae3ca47ec36a1db525f44d86068fc6aeff480dfd4c08e47387" => :high_sierra
    sha256 "686b770c6a8707757355f124b592a9eb867e21626081993e0e7e11b060555c21" => :sierra
    sha256 "596c7db4aa25f3e0378a7b3ed19e729d1ffe1e892c45e7b609f6c7ab2bf134fa" => :el_capitan
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
