class AutoEditor < Formula
  desc "Effort free video editing!"
  homepage "https://auto-editor.com"
  url "https://github.com/WyattBlue/auto-editor/archive/refs/tags/30.0.0.tar.gz"
  sha256 "326f5d3dfa2c475679b23d5d67957fe4c0fc30b37b61c1b302f9f32400428ca6"
  license "Unlicense"
  head "https://github.com/WyattBlue/auto-editor.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7dcec00389e400aed1b3073f16cd4703db73533d2fcbfd97f1793a70980323c5"
    sha256 cellar: :any,                 arm64_sequoia: "0450d024573842a63d53273888e1098a904d9c2c70e77c652bfcbdf7133a18ef"
    sha256 cellar: :any,                 arm64_sonoma:  "cdadc1d5214628ebe3e1137ebdef0e90d5635fbd3800e1eb733efcddc6bd6c3a"
    sha256 cellar: :any,                 sonoma:        "81e87b4fe6090680b6dec26c3be77e79dec096f83b7328ff4bc088aee5b1cc1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "131a8cfb77d68abd9fca60c8807a74d1fc4cafd5c0a4d829cf2d186baf43d6c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b6aca1bd4f2d5b0a84fb800f0717a60e4ed27c34b57656cc321ab77eac1bf5f"
  end

  depends_on "nim" => :build
  depends_on "pkgconf" => :build
  depends_on "dav1d"
  depends_on "ffmpeg"
  depends_on "lame"
  depends_on "libvpx"
  depends_on "opus"
  depends_on "svt-av1"
  depends_on "x264"
  depends_on "x265"

  def install
    ENV["DISABLE_VPL"] = "1"
    ENV["DISABLE_WHISPER"] = "1"
    system "nimble", "make"
    bin.install "auto-editor"
    generate_completions_from_executable(bin/"auto-editor", "completion", "-s", shells: [:zsh])
  end

  test do
    mp4in = testpath/"video.mp4"
    mp4out = testpath/"video_ALTERED.mp4"
    system "ffmpeg", "-filter_complex", "testsrc=rate=1:duration=5", mp4in
    system bin/"auto-editor", mp4in, "--edit", "none", "--no-open"
    assert_match(/Duration: 00:00:05\.00,.*Video: h264/m, shell_output("ffprobe -hide_banner #{mp4out} 2>&1"))
  end
end
