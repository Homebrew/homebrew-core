class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_2.6.1.tar.gz"
  sha256 "48de7045a36eb718d55b0dfd68a797380b5390af99c9737a4dfba0fb678ed2b4"
  head "https://github.com/dtschump/gmic.git"

  bottle do
    cellar :any
    sha256 "27047e8a7233de950aadea79168c78eec373e0d10d4cdd63757e46e9779cfadb" => :mojave
    sha256 "73f660a28e2c7a26c0b01726d50d110d8efddb4eb8f053f3bf6a13e5076c7d81" => :high_sierra
    sha256 "62ea79a15d62ba013c9dbdc5d7c3861fa2e575d50e0a4d6ea7ba6e22fae3e388" => :sierra
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
