class Arss < Formula
  desc "Analyze a sound file into a spectrogram"
  homepage "http://arss.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arss/arss/0.2.3/arss-0.2.3-src.tar.gz"
  sha256 "e2faca8b8a3902226353c4053cd9ab71595eec6ead657b5b44c14b4bef52b2b2"

  bottle do
    cellar :any
    sha256 "2311c31ae2e80905dfc41c8adb9639314664103352540b198f24c54e0c102550" => :sierra
    sha256 "5da45934b19d0cab02c809932fb8c5da3fd76d2f781bc9e2e7a98fa1825989eb" => :el_capitan
    sha256 "268225389842f4952424b17c7b94759b7a3d3009053b50718f1e4155b7eace86" => :yosemite
    sha256 "7159b6b56ad3878bc84b9fdf9d708f0828637db64ae12ef96f39820c2f22d061" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "fftw"

  def install
    cd "src" do
      system "cmake", ".", *std_cmake_args
      system "make", "install"
    end
  end
end
