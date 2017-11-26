class Glslviewer < Formula
  desc "Live-coding console tool that renders GLSL Shaders"
  homepage "http://patriciogonzalezvivo.com/2015/glslViewer/"
  url "https://github.com/patriciogonzalezvivo/glslViewer/archive/1.5.tar.gz"
  sha256 "53f87185f79c4a9d77646552548e5b6bfe273447842c2993d22a9e4a247820e9"
  head "https://github.com/patriciogonzalezvivo/glslViewer.git"

  bottle do
    cellar :any
    sha256 "421add871b2d434d738f2a5d305f5414bce357575ad0361cb2ddfdfc1c8e5b7a" => :high_sierra
    sha256 "0f7df457c79e81ba7a0ba1a51b8722b5061074bc29ad2f57359ccf624ad05f80" => :sierra
    sha256 "18d88b29b611adc27e31de650e29b31d6a750ed7f5985fe34bc35b6f4a5172e4" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "glfw"

  def install
    system "make"
    bin.install Dir["bin/*"]
  end

  test do
    system "#{bin}/glslViewer", "--help"
  end
end
