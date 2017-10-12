class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_2.1.1.tar.gz"
  sha256 "8cd1193201f204b052de835bf36b8432b8db83e10b2b71491565ec795c114e64"
  head "https://github.com/dtschump/gmic.git"

  bottle do
    cellar :any
    sha256 "efaea3b547ef6429ac01dec0be1ef2ab4b5b5c96a7cb46d308da104face39c59" => :high_sierra
    sha256 "5c3bbcc8dc9c30362ac664ea71b6a24b70c34ac934ccd2dd37459df766a7b77a" => :sierra
    sha256 "da5d605b414d8607d2abef58ad28953eb4e673ec424343df83b25d9e16344202" => :el_capitan
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
