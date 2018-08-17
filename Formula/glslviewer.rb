class Glslviewer < Formula
  desc "Live-coding console tool that renders GLSL Shaders"
  homepage "http://patriciogonzalezvivo.com/2015/glslViewer/"
  url "https://github.com/patriciogonzalezvivo/glslViewer/archive/1.5.2.tar.gz"
  sha256 "466b54cdbf8e07be867af25c8ee982c4a7efbe593e7aed1740b5bb18332c30de"
  head "https://github.com/patriciogonzalezvivo/glslViewer.git"

  bottle do
    cellar :any
    sha256 "6d9820c28357c0a0bde472c2c9392d165fa7aac4acd77524e1bc96455b8c229b" => :high_sierra
    sha256 "ef61951f9425cf1e75d4d81a7266ead20f90acc05d3fa7be93e28c43db8405f1" => :sierra
    sha256 "b4f030019b09e6ddca5aac040fc22df316041fc8d87a388148e10e6ade653334" => :el_capitan
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
