class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_2.5.7.tar.gz"
  sha256 "1cc71b48c1c3da928031b7f32cf3fe4757a07b4f21c3af4167389d54cf2dee5f"
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
