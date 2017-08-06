class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_2.0.2.tar.gz"
  sha256 "7da9f08d62a9d23fc8badbc7c819cf76f4a9ce3db763710268fdcb80d83ecfc6"
  revision 1
  head "https://github.com/dtschump/gmic.git"

  bottle do
    cellar :any
    sha256 "43efa3e7e2cec2f14f40efae2222599470b439fca333a6268bc1998c9b3d5b67" => :sierra
    sha256 "15c4f2b928cf612d8eea44f802118925c2f37dc308c964ad67cf66ffc3672b22" => :el_capitan
    sha256 "f85abed33cac00a5075928ca21b3a3b6750cda09648a3d0e70fe9d35659dc3a7" => :yosemite
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
