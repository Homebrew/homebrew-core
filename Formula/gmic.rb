class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_2.1.0.tar.gz"
  sha256 "94a68f421fdbb99476c7b35065ff3386f7d26d319d386c99c702df3969c221b0"
  head "https://github.com/dtschump/gmic.git"

  bottle do
    cellar :any
    sha256 "c7f3134866bc678f1dd799ab75171a1d508a7af487d9c0044cbea1aefb67a92b" => :sierra
    sha256 "e93a5da11bbd20ad95f1b21d502e7d32b98aebb9990bd915ade4026843a8b82d" => :el_capitan
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
