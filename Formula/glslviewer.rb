class Glslviewer < Formula
  desc "Live-coding console tool that renders GLSL Shaders"
  homepage "http://patriciogonzalezvivo.com/2015/glslViewer/"
  url "https://github.com/patriciogonzalezvivo/glslViewer/archive/1.6.6.tar.gz"
  sha256 "10bd34b535e495358ed8f2ae709840965cdc2a4dedee794e795d59ae3ec33518"
  license "BSD-3-Clause"
  head "https://github.com/patriciogonzalezvivo/glslViewer.git"

  bottle do
    cellar :any
    sha256 "e7adfe134539bb80d62c34d58bd2f86c65098cb6905caddcf84b6f9e90e66182" => :catalina
    sha256 "2ece284a5fdf51234acba1a1daa649ca3263b1029b7fc8c74d7dd5c104b3a46e" => :mojave
    sha256 "f93b11c3243d59f301b0ed4f70249f45eeeafafd150ac46d372ac0616eced53b" => :high_sierra
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
