class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_2.6.4.tar.gz"
  sha256 "4cd88b2dca6b9b1a330ab4556d36656bafb98e4e9814bf0448545b27ef18dae3"
  head "https://github.com/dtschump/gmic.git"

  bottle do
    cellar :any
    sha256 "66f2d1decdb82ba88229562695388db7e6e17882a57b1279d793b2f5ef157672" => :mojave
    sha256 "1c4da113ba527e2092b166ac1565909ad38b9cc7b5ba63c25203663bb63931ca" => :high_sierra
    sha256 "05b31f910931ddc35157e5db7a21fe61b216015bcb40cb9f228992feec3e562a" => :sierra
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
