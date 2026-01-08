class AutoEditor < Formula
  desc "Efficient media analysis and rendering"
  homepage "https://auto-editor.com"
  url "https://github.com/WyattBlue/auto-editor/archive/refs/tags/29.6.1.tar.gz"
  sha256 "c32ffc9e869ba1e4f7bae8221727e1e4d6aefe87ef10479fe6d1efee17a7be9a"
  license "Unlicense"
  head "https://github.com/WyattBlue/auto-editor.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "28907b8748ee92a014e5e62ec824980422ba07780d0e6818f1f3b9bba117e371"
    sha256 cellar: :any,                 arm64_sequoia: "fa1a86860a2df94e679a12caa0c2f030a346aeb15460b90276f169ba33296859"
    sha256 cellar: :any,                 arm64_sonoma:  "d587f58f716e3075be28e4acfb9b586ac3df712dbb60b827e1c2b209373e0bbb"
    sha256 cellar: :any,                 sonoma:        "41ddc3671033f528d89d0644cc11d9d07a9acae26b0f314443e02738a5551e24"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0def3cd3306f76824ef6c026461b1a6d86e39f591f0622cbceffb2611e0592cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64acf7157012568e943769378ce55bec3cf89534283b9d0e5eaaaf747a703c50"
  end

  depends_on "nim" => :build
  depends_on "pkgconf" => :build
  depends_on "dav1d"
  depends_on "ffmpeg"
  depends_on "lame"
  depends_on "libvpx"
  depends_on "llama.cpp"
  depends_on "opus"
  depends_on "svt-av1"
  depends_on "whisper-cpp"
  depends_on "x264"
  depends_on "x265"

  def install
    system "nimble", "make"
    generate_completions_from_executable("nimble", "zshcomplete", "--silent", shells: [:zsh])
    bin.install "auto-editor"
  end

  test do
    mp4in = testpath/"video.mp4"
    mp4out = testpath/"video_ALTERED.mp4"
    system "ffmpeg", "-filter_complex", "testsrc=rate=1:duration=5", mp4in
    system bin/"auto-editor", mp4in, "--edit", "none", "--no-open"
    assert_match(/Duration: 00:00:05\.00,.*Video: h264/m, shell_output("ffprobe -hide_banner #{mp4out} 2>&1"))
  end
end
