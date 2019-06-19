class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_2.6.6.tar.gz"
  sha256 "86c14da90daa0b3c09265b7b07976bf3f3a76f5b0786fecfd9fc3d9332ce0da0"
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
