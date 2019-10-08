class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_2.7.2.tar.gz"
  sha256 "f8438bceb337d596aa91383acb7beb4df477f0d07b267c4f6806e0e55268bef3"
  head "https://github.com/dtschump/gmic.git"

  bottle do
    cellar :any
    sha256 "9a5039f1892b3c95ef04b16afb5d41f3b655ab92c044231b83f70ee4b648810e" => :mojave
    sha256 "c8dc844c542996190148a11049e5af4341bf9ad186b8661a3e70f2ad0a11c5fb" => :high_sierra
    sha256 "22161ed15c6c710df2323d3663f0e3932d1e97544559c91a52aa283b1720b14e" => :sierra
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
