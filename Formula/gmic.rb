class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_2.6.1.tar.gz"
  sha256 "48de7045a36eb718d55b0dfd68a797380b5390af99c9737a4dfba0fb678ed2b4"
  head "https://github.com/dtschump/gmic.git"

  bottle do
    cellar :any
    sha256 "2bac867719f9db5b5a1c93ac96a232a78a407b0c35b763149f193199543d7fb3" => :mojave
    sha256 "be7e890cb26bed10e794af4198a7cfd46fb23a8b6c0f128a274efb49925c5112" => :high_sierra
    sha256 "4fc775583bb844aa961be5090f6033ea9ad07d3ba7cc16452632fa4963d18382" => :sierra
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
