class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_1.7.9.tar.gz"
  url "https://gmic.eu/files/source/gmic_1.7.9.tar.gz"
  version "1.7.9.0.2016.12.02"
  sha256 "152f100eb139a5f6e5b3d1e43aaed34f2b3786f72f52724ebde5e5ccea2c7133"
  head "https://github.com/dtschump/gmic.git"

  bottle do
    cellar :any
    sha256 "bd8dd557d4d4e0ab3cbe08738b9ea618e6a25c2ff0510798c92b613df7f9e67b" => :sierra
    sha256 "ce8ef788b94cb32daceb0d5cbd30670b1969812523d5c2532333885fed8d3c27" => :el_capitan
    sha256 "8e8b64e4ac2ab1c1a48d9037ff2a44f85582f68472631d67118a4e6d4f3532d2" => :yosemite
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
