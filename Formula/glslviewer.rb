class Glslviewer < Formula
  desc "Live-coding console tool that renders GLSL Shaders"
  homepage "http://patriciogonzalezvivo.com/2015/glslViewer/"
  url "https://github.com/patriciogonzalezvivo/glslViewer/archive/1.6.1.tar.gz"
  sha256 "2408e1662f2d4dd1922f00a747090c13ee8aff561123bdc86aff9da77b3ccf74"
  license "BSD-3-Clause"
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
