class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_2.0.2.tar.gz"
  sha256 "7da9f08d62a9d23fc8badbc7c819cf76f4a9ce3db763710268fdcb80d83ecfc6"
  head "https://github.com/dtschump/gmic.git"

  bottle do
    cellar :any
    sha256 "eefdb969b3d6013bf99862a708f8de50ad01841b04cf1461732e2e547c85f62b" => :sierra
    sha256 "642156fe92163ca558bfa895ae0ca58540215fcc3f4719ce4c9fade846ee5058" => :el_capitan
    sha256 "56d41afee911ad8e1642a4d7994f522e064442a00fb3db185a40fa964fa53326" => :yosemite
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
