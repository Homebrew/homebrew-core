class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_2.7.4.tar.gz"
  sha256 "cd9b40fa8df8a0bb47388071096c768a9d4908af574f0e98cc8515410d0b2c40"
  head "https://github.com/dtschump/gmic.git"

  bottle do
    cellar :any
    sha256 "966ec583c7d5bdb9163f53f07152d61c32419c8cc9e9ee490ad4e07197f926a2" => :catalina
    sha256 "c5aa43bbe459e56bdd44c299fa07e5aae00a03a26f56fd45ec9b7c16f7dd4a17" => :mojave
    sha256 "f64474e6172f7313efb103687c11148a0f0eee0bc37e2daeafea38af2aa6d9b6" => :high_sierra
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
