class Glslviewer < Formula
  desc "Live-coding console tool that renders GLSL Shaders"
  homepage "http://patriciogonzalezvivo.com/2015/glslViewer/"
  url "https://github.com/patriciogonzalezvivo/glslViewer/archive/1.5.4.tar.gz"
  sha256 "22ae0d32592d8864f77c6b04944b3b38210be36e47e7c8231b1e56ceba5a652f"
  head "https://github.com/patriciogonzalezvivo/glslViewer.git"

  bottle do
    cellar :any
    sha256 "aedc933b7e48c5b29ff4473c1d2f99d78ba2a6384adbc5efd4d2942f9c7da4d5" => :high_sierra
    sha256 "560ad028e45f823be510aa37fbb1ce4f3b08adfdb25fccc5beb1767e07158937" => :sierra
    sha256 "ace197fb8244a3db9941b9053f0f8fac50a8ce5ce3cc5874da0001f5b9fa4f3e" => :el_capitan
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
