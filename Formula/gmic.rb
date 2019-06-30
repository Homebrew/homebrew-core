class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_2.6.7.tar.gz"
  sha256 "2e5535d1bae66254136e928428750aac8efcef6f4413fc352b6de9ce8ac8b0ff"
  head "https://github.com/dtschump/gmic.git"

  bottle do
    cellar :any
    sha256 "c9833d6e57fc89d6b6c2c009e44022954d561b030f4843ac5ffde5c7fd44ed8f" => :mojave
    sha256 "90dba8c8ab03e9dbaf7656afb38b658c19bf47c06ade329aed6035d87ed62fb4" => :high_sierra
    sha256 "b1b2fe20e7a0a3235e66c1ad82dbe603664f0996761e775970265a4d51254e1e" => :sierra
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
