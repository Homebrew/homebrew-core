class Glslviewer < Formula
  desc "Live-coding console tool that renders GLSL Shaders"
  homepage "http://patriciogonzalezvivo.com/2015/glslViewer/"
  url "https://github.com/patriciogonzalezvivo/glslViewer/archive/1.6.0.tar.gz"
  sha256 "9235fefc41130ad4088c50c76a1f246069fe4986e42df972e352549d16d935b7"
  head "https://github.com/patriciogonzalezvivo/glslViewer.git"

  bottle do
    cellar :any
    sha256 "4df521fbbc143343c32dd68f743f337954063f0852dcab3aa75a08a8b8be3509" => :catalina
    sha256 "c15fc78aa3d9ec10dadabac7e2d240c6b05bfee77d0248c7c05f8ffea06ec971" => :mojave
    sha256 "c1bc3d4aaaba644a4c825c090d0aa2987ae243c78f7e931c99ef6631d6f81cbc" => :high_sierra
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
