class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_2.5.6.tar.gz"
  sha256 "052455a96df2a1a663ee974f9cc31850387adb2d2f5f2d91adc441e66d4db2d4"
  head "https://github.com/dtschump/gmic.git"

  bottle do
    cellar :any
    sha256 "5b48093b42ba10ebd6fe99cd5c139b5500365539a8853f52388b1c67e00effba" => :mojave
    sha256 "f9c848b24bc17175b2c017d0d33dd517dabd489e00beef8600b3fdbea182a5eb" => :high_sierra
    sha256 "5102ceccc05e6711f8779818ee3ac268abe47052cc7f31fe26e4826dff95973c" => :sierra
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
