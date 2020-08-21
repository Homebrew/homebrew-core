class Glslviewer < Formula
  desc "Live-coding console tool that renders GLSL Shaders"
  homepage "http://patriciogonzalezvivo.com/2015/glslViewer/"
  url "https://github.com/patriciogonzalezvivo/glslViewer/archive/1.6.8.tar.gz"
  sha256 "3792984457c9487cd1f87374b7698f3b66f4480b3eeac7d940a2ecf9e74dee3e"
  license "BSD-3-Clause"
  head "https://github.com/patriciogonzalezvivo/glslViewer.git"

  bottle do
    cellar :any
    sha256 "77d660ee09f6dd7c1df4d7758dc968c023481972379209f59c7b11c5ed71c971" => :catalina
    sha256 "35f464a7ca135ee532a1f71c46ce2cdf0c339eba4536f399f37cb62339a752ed" => :mojave
    sha256 "c684c5de7a7fc314fa10b7bdfe9aae83384098b7df5acf87973d7c66486bb31a" => :high_sierra
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
