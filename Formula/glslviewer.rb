class Glslviewer < Formula
  desc "Live-coding console tool that renders GLSL Shaders"
  homepage "http://patriciogonzalezvivo.com/2015/glslViewer/"
  url "https://github.com/patriciogonzalezvivo/glslViewer/archive/1.5.5.tar.gz"
  sha256 "28a784d701294fd335031ab293c5f4764a498f84714b1ae677dbc4e05ed94b23"
  head "https://github.com/patriciogonzalezvivo/glslViewer.git"

  bottle do
    cellar :any
    sha256 "81841fc4594a7e06444a0ace80d8ad8c7ea3738325d86e968ba844bc27c8d085" => :catalina
    sha256 "e39a6cd0133d664e812e5148d01a7da705d23253548cb7cd0bae58324f7757b8" => :mojave
    sha256 "79145bf1417520ea637f08bc4b1cc3071f2cef6404ddec54fea7df701860eece" => :high_sierra
    sha256 "c81f27a48b0fbbca9e091d76893d9e9e6064e25c5febce922b800318cb1bf1e8" => :sierra
    sha256 "48f30017a20bbbe4835dfcba05f64b992ffd6a30e95f8f6676ab7ffd87077749" => :el_capitan
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
