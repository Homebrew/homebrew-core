class Glslviewer < Formula
  desc "Live-coding console tool that renders GLSL Shaders"
  homepage "http://patriciogonzalezvivo.com/2015/glslViewer/"
  url "https://github.com/patriciogonzalezvivo/glslViewer/archive/2.0.3.tar.gz"
  sha256 "5d56070e81015e047050e55834c4bbe30e98ba754c84efc737b78fb16739781b"
  license "BSD-3-Clause"
  head "https://github.com/patriciogonzalezvivo/glslViewer.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e1031838f5fa625dd142dd058a812aed71f7f7696fff345b46bec303a66a46df"
    sha256 cellar: :any,                 arm64_big_sur:  "3fcd463c03fe4174fdf809d7fce0ec612e1148241d1974ce6424a47a8624e894"
    sha256 cellar: :any,                 monterey:       "5a800f933f5c444247b7f2644578a0cfbd8c283853bee15387769cf6146268be"
    sha256 cellar: :any,                 big_sur:        "3af1d9e5b62064c8e62f858f5f57759e3078c4f266650aaae5ef6d32d9d3e789"
    sha256 cellar: :any,                 catalina:       "98b9ccf60ad6b4b7cb614064a6c83a4b531cf10949d1d26a5107902a0cb3ac63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c5f389e38491eb889fdd306f89e07e2f54c4e75c2454290f31347231c31c1fa"
  end

  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "glfw"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5" # rubberband is built with GCC

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
