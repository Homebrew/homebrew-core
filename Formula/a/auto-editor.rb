class AutoEditor < Formula
  desc "Effort free video editing!"
  homepage "https://auto-editor.com"
  url "https://github.com/WyattBlue/auto-editor/archive/refs/tags/31.6.0.tar.gz"
  sha256 "9cea80d4c58bd454dc760e587cd73a419bd997cdcdfffc84382ea95dd8d72902"
  license "Unlicense"
  head "https://github.com/WyattBlue/auto-editor.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "97d2aa8abbd483d697d5a32a86e1721fc01776521e17ca3da5173786b60569e9"
    sha256 cellar: :any, arm64_tahoe:       "cc12aeb050ebce237c8631520ec0ea7da3d6f98fde7e7a9497bef194100d5695"
    sha256 cellar: :any, arm64_sequoia:     "c41fc98f750291eb3fc649a43a1b30f9f44f22073d6b8df86c3dab9e469ada69"
    sha256 cellar: :any, arm64_linux:       "332e6c7accdaab5210b6b7f43954ab31a5874229f0fd4c1308265e1b119958e2"
    sha256 cellar: :any, x86_64_linux:      "3eef83b9cb6ed93dda604be1ee9920dd1a552e693a9100045767ad423f52c35b"
  end

  depends_on "nim" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "ggml"
  depends_on "whisper.cpp"

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

    whisper = Formula["whisper.cpp"]
    system bin/"auto-editor", "whisper", whisper.pkgshare/"jfk.wav",
      whisper.pkgshare/"for-tests-ggml-tiny.bin"
  end
end
