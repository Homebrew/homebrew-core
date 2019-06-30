class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_2.6.7.tar.gz"
  sha256 "2e5535d1bae66254136e928428750aac8efcef6f4413fc352b6de9ce8ac8b0ff"
  head "https://github.com/dtschump/gmic.git"

  bottle do
    cellar :any
    sha256 "d2c6b8de78d9dba1577f81ffeae801b1bd37a05bde5338d507517c93e36a9e18" => :mojave
    sha256 "2b1358263e107f6a92323ebcdd153d5ba9aeee9c7e744f17311c8ff75c065204" => :high_sierra
    sha256 "22b6951886f9baa334a087dca6e7682e249f0fddff140946ebdbf1c232f81506" => :sierra
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
