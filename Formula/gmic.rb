class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_2.1.5.tar.gz"
  sha256 "2f3de90a09bba6d24c89258be016fd6992886bda13dbbcaf03de58c765774845"
  revision 2
  head "https://github.com/dtschump/gmic.git"

  bottle do
    cellar :any
    sha256 "a83169420df4822da448240289587a0920a00a61e7b021a3d3e745df7fb01534" => :mojave
    sha256 "26fdd18da72d898ee0ba1b1ff26ea1d117af32ca00ec738c8777d799ee14fe30" => :high_sierra
    sha256 "8d6e688ead9ccb298a1bca1d3ef96c8db990cb539fd6300138b2114c8756aca6" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "fftw"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"

  def install
    cp "resources/CMakeLists.txt", buildpath
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
