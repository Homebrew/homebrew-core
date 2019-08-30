class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_2.7.0.tar.gz"
  sha256 "8629c39ca5fa02c44a462727d36f50557e1397af2feeddf39628608c028824d3"
  head "https://github.com/dtschump/gmic.git"

  bottle do
    cellar :any
    sha256 "522dc4f095ecf53ef8fe2d2fd9eba916432bbf8c912eb36a8cdadf3eb8992b91" => :mojave
    sha256 "5d538dbfc29bd10ddc2bd74580e832515fa6091d114805cc166f2cab546e9135" => :high_sierra
    sha256 "7ac12d8a6f9771b329d5b336ae17bbbb11ad4abdc3514b4671ba55b9c059c1ca" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "fftw"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"

  def install
    system "cmake", *std_cmake_args,
                    "-DENABLE_FFMPEG=OFF",
                    "-DENABLE_OPENCV=OFF",
                    "-DENABLE_OPENEXR=OFF",
                    "-DENABLE_X=OFF"
    system "make", "install"
  end

  test do
    %w[test.jpg test.png].each do |file|
      system bin/"gmic", test_fixtures(file)
    end
  end
end
