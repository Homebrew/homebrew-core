class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_2.5.3.tar.gz"
  sha256 "be723f9efb1b295d1d019037c72217136be582a7af26d5d044a2009df0c4e6ec"
  head "https://github.com/dtschump/gmic.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "eaff00c94294d5127e2bda3e6337fb211bdae2e0b71d288a9ea32c2871611894" => :mojave
    sha256 "840b556cf36d1e965cda69a690eb5abeb47dc9fd5d9ba27c49b3226ba144e12e" => :high_sierra
    sha256 "faa35aaf650b223d121ca2aa66f395b3429695bc3800e0d31805a0e2b121dea2" => :sierra
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
