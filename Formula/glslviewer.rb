class Glslviewer < Formula
  desc "Live-coding console tool that renders GLSL Shaders"
  homepage "http://patriciogonzalezvivo.com/2015/glslViewer/"
  url "https://github.com/patriciogonzalezvivo/glslViewer/archive/1.6.8.tar.gz"
  sha256 "3792984457c9487cd1f87374b7698f3b66f4480b3eeac7d940a2ecf9e74dee3e"
  license "BSD-3-Clause"
  head "https://github.com/patriciogonzalezvivo/glslViewer.git"

  bottle do
    cellar :any
    sha256 "f3ce8f0e2fc1954a66507e0035001a53999b3db181800a7e603adb49d2f545e7" => :big_sur
    sha256 "8af79674f9aec125cac3abaca849ac39aaaf6189685818d95509cec45c026536" => :catalina
    sha256 "db43cd0ba38d9cf6a1d73f2be1b4d4d3bc0c8224219ef9a8c15449c89f75bd51" => :mojave
    sha256 "b491ac4f3101dd7c0ba68d66f0df68400522aa1ab9d777f7c1f29ffabb56c3c2" => :high_sierra
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
