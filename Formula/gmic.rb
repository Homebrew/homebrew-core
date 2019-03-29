class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_2.5.5.tar.gz"
  sha256 "46246a7f37740cfba22b6ee77f509a9e874cc70b7e1169ef195dcf8bb2b98d13"
  head "https://github.com/dtschump/gmic.git"

  bottle do
    cellar :any
    sha256 "c2505ebec43442e16ded4e4e0f74b41779bb60297755f9d4b7976634ffd96b21" => :mojave
    sha256 "0c861bb5ab69f108770ccbd9973b54980f447033db613614c1e6684a452f1eec" => :high_sierra
    sha256 "4f8c8f6195426605e456533e1f2705a012c1fd2166d2ba14d6524357c14f2061" => :sierra
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
