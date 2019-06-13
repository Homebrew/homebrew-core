class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_2.6.5.tar.gz"
  sha256 "b0da81a3ed7ee25475ffb0ca148c755f7a7028650614e7e103a3fc507a81e10e"
  head "https://github.com/dtschump/gmic.git"

  bottle do
    cellar :any
    sha256 "5734395080225fda971dd6b043cbe648cb1cd7428783bb1bbf9fabf9010f64dd" => :mojave
    sha256 "6161ff32abff67988a6ebe473fd666405178d4d7b49a8085adc64a26e3ce34ea" => :high_sierra
    sha256 "3b180a440980ef44746e71a06f414b4346e2d3952230e7d61fcd5a1ec18db758" => :sierra
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
