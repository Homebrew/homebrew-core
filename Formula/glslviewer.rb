class Glslviewer < Formula
  desc "Live-coding console tool that renders GLSL Shaders"
  homepage "http://patriciogonzalezvivo.com/2015/glslViewer/"
  url "https://github.com/patriciogonzalezvivo/glslViewer/archive/1.5.tar.gz"
  sha256 "53f87185f79c4a9d77646552548e5b6bfe273447842c2993d22a9e4a247820e9"
  head "https://github.com/patriciogonzalezvivo/glslViewer.git"

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
