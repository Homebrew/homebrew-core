class Glslviewer < Formula
  desc "Live-coding console tool that renders GLSL Shaders"
  homepage "http://patriciogonzalezvivo.com/2015/glslViewer/"
  url "https://github.com/patriciogonzalezvivo/glslViewer/archive/1.7.0.tar.gz"
  sha256 "4a03e989dc81587061714ccc130268cc06ddaff256ea24b7492ca28dc855e8d6"
  license "BSD-3-Clause"
  head "https://github.com/patriciogonzalezvivo/glslViewer.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "0ec97c2e9044bbfd60b9e3a351ac776f2cda6ac13cf9a4bc126d922e2da2d253"
    sha256 cellar: :any,                 big_sur:       "bcaaa427f4cfaf2736c995c24235be606a8e0e83cbaaf495097f684d2f7de069"
    sha256 cellar: :any,                 catalina:      "17f665c2d066a6a01023300ed8a1fbad50ef078503978b3e7b4db63e6d483aba"
    sha256 cellar: :any,                 mojave:        "94c59b694e9feeeb388aaf5aee69c387e4ea02348f178e34b715167b3af636af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abdda11e8c83614d9af904e946ca537fb5ae9d7333ee9a7d618ed3f9585ce81f"
  end

  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "glfw"

  # From miniaudio commit in https://github.com/patriciogonzalezvivo/glslViewer/tree/#{version}/include
  resource "miniaudio" do
    url "https://raw.githubusercontent.com/mackron/miniaudio/199d6a7875b4288af6a7b615367c8fdc2019b03c/miniaudio.h"
    sha256 "ee0aa8668db130ed92956ba678793f53b0bbf744e3f8584d994f3f2a87054790"
  end

  def install
    (buildpath/"include/miniaudio").install resource("miniaudio")
    system "make"
    bin.install "glslViewer"
  end

  test do
    system "#{bin}/glslViewer", "--help"
  end
end
