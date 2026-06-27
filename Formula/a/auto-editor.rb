class AutoEditor < Formula
  desc "Effort free video editing!"
  homepage "https://auto-editor.com"
  url "https://github.com/WyattBlue/auto-editor/archive/refs/tags/31.0.2.tar.gz"
  sha256 "9084df86ad08d5265c5741495e6e02b26ab5469ee22de60e09241a5ce8bada95"
  license "Unlicense"
  head "https://github.com/WyattBlue/auto-editor.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8344d35836090a53f8c5c8254619473e920724b2a5279aeb12823fc6fd39a6f2"
    sha256 cellar: :any, arm64_sequoia: "db37dbec4b3f97adf0b5d07e1228767c4a434427519015a1e67ab3b338fc5b30"
    sha256 cellar: :any, arm64_sonoma:  "870a2827cdb326324b426c78f4ee63c31330977bc35325972879552f09a649d0"
    sha256 cellar: :any, sonoma:        "11b91e62e50a233ab1404b3ccebfc3c96fa96a4f3b4cc67348576943579aff55"
    sha256 cellar: :any, arm64_linux:   "f4a58930be929fe3c2131426842d3873a04b67bdbe84cb6c32361b5930423038"
    sha256 cellar: :any, x86_64_linux:  "2a0879d70ffbf3deaa277cb1a8f64def233b90aafb77e593045e8bb39f592319"
  end

  depends_on "nim" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"

  def install
    system "nimble", "brewmake"
    bin.install "auto-editor"
    generate_completions_from_executable(bin/"auto-editor", "completion", "-s", shells: [:zsh])
  end

  test do
    mp4in = testpath/"video.mp4"
    mp4out = testpath/"video_ALTERED.mp4"
    system "ffmpeg", "-filter_complex", "testsrc=rate=1:duration=5", mp4in
    system bin/"auto-editor", mp4in, "--edit", "none"
    assert_match(/Duration: 00:00:05\.00,.*Video: h264/m, shell_output("ffprobe -hide_banner #{mp4out} 2>&1"))
  end
end
