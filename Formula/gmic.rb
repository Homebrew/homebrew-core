class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_2.7.5.tar.gz"
  sha256 "a6854264c8ab4e7df33e19fe98314b6abcf663060e9baa18731f163eaabc1401"
  head "https://github.com/dtschump/gmic.git"

  bottle do
    cellar :any
    sha256 "1e0649a3f5aed96511f7cc72ec341777bd64f5318ac8ae0947d83b0b8f7bd3f1" => :catalina
    sha256 "bde0782b9e07ebe1f5b2cb5de94d17c12c74f75dff141049e727a1c9f7b26e92" => :mojave
    sha256 "0ff7708a4498fb204924d8a5c925b92e724c21ef409f29d9f3427d980d2ac7e2" => :high_sierra
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
