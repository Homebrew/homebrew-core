class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_2.6.4.tar.gz"
  sha256 "4cd88b2dca6b9b1a330ab4556d36656bafb98e4e9814bf0448545b27ef18dae3"
  head "https://github.com/dtschump/gmic.git"

  bottle do
    cellar :any
    sha256 "a410ed9a93a6709bf84c9b5e356750e098fe9a2cf6aa881cd5c18b4d7ef0c17c" => :mojave
    sha256 "afac6313db0d1ba9396c51c145bf52c4cb90a006bcd2d79cd8fb82a08cef7077" => :high_sierra
    sha256 "79f3ae2684a6740a2b33ff60e081151deba4a89b05f0d290506d0be9ae9aa347" => :sierra
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
