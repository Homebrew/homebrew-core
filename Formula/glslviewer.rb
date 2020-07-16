class Glslviewer < Formula
  desc "Live-coding console tool that renders GLSL Shaders"
  homepage "http://patriciogonzalezvivo.com/2015/glslViewer/"
  url "https://github.com/patriciogonzalezvivo/glslViewer/archive/1.6.2.tar.gz"
  sha256 "12dc9d9ecdf4876c0b276555ea47376c87a1adaea2ab03f1eb3736701cbbc885"
  license "BSD-3-Clause"
  head "https://github.com/patriciogonzalezvivo/glslViewer.git"

  bottle do
    cellar :any
    sha256 "506e7fc2898863823d8b481c4c89e782d6b82624b5fef6284181d502dce2f4a3" => :catalina
    sha256 "15b623c6dce054c5529940a152c4037b5821a50cee7d66b5b3ea78726294792a" => :mojave
    sha256 "764379ab8e66240539d5a7c057313887ef56ee26d2625beb44eab481ba9762a2" => :high_sierra
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
