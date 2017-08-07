class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_2.0.2.tar.gz"
  sha256 "7da9f08d62a9d23fc8badbc7c819cf76f4a9ce3db763710268fdcb80d83ecfc6"
  revision 1
  head "https://github.com/dtschump/gmic.git"

  bottle do
    cellar :any
    sha256 "0d01c756161cf7c34c7060fa504cec81f0d6d0862ed631b1e981b10a12b6f684" => :sierra
    sha256 "d10d5d6c2e9e4a409c866647e8657d78d2c347af7c4457e73c05ef5d3fe0f016" => :el_capitan
    sha256 "00c1064833f27be4b82f70f4e2c5668aa40e6a410db8139b65aa0973899f7395" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "jpeg" => :recommended
  depends_on "libpng" => :recommended
  depends_on "fftw" => :recommended
  depends_on "homebrew/science/opencv" => :optional
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
