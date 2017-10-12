class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_2.1.1.tar.gz"
  sha256 "8cd1193201f204b052de835bf36b8432b8db83e10b2b71491565ec795c114e64"
  head "https://github.com/dtschump/gmic.git"

  bottle do
    cellar :any
    sha256 "45d8a1c19ddbcb1fda2203f5eb32e3ce960e14abb7566fdb7c3a6f1d87e578f5" => :high_sierra
    sha256 "e2664e677d8ef884c036a255a76daf80b8ed37a9e430a528f237072fbf24a385" => :sierra
    sha256 "c2d448cc51b7f94a5d0f2752ba333dab7a2dedf5692251e1b4582ec0a3d56371" => :el_capitan
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
