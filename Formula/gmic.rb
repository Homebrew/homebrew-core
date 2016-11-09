class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_1.7.8.tar.gz"
  sha256 "3a2f32d79714239cfa56ecb10799b7d73362b4e2a852444bc24866272cd041a4"
  head "https://github.com/dtschump/gmic.git"

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

    # https://github.com/dtschump/gmic/issues/11
    man1.install "man/gmic.1.gz"
  end

  test do
    %w[test.jpg test.png].each do |file|
      system bin/"gmic", test_fixtures(file)
    end
  end
end
