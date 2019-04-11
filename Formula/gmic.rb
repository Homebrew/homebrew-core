class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_2.5.6.tar.gz"
  sha256 "052455a96df2a1a663ee974f9cc31850387adb2d2f5f2d91adc441e66d4db2d4"
  head "https://github.com/dtschump/gmic.git"

  bottle do
    cellar :any
    sha256 "08253be8bf7fac333fa32ffdb056d2e003993fdab3f38aa230d23a26e0516e6c" => :mojave
    sha256 "0eefefa535cf8155a2f2089488eda874c984f29a6121e26ebc3e739cb34bdf1b" => :high_sierra
    sha256 "8d5de939aa98dda2ecd4f178c32f87efa83a7070c02333cdec295886477d1a05" => :sierra
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
