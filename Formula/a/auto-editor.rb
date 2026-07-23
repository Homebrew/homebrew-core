class AutoEditor < Formula
  desc "Effort free video editing!"
  homepage "https://auto-editor.com"
  url "https://github.com/WyattBlue/auto-editor/archive/refs/tags/31.3.2.tar.gz"
  sha256 "25fa8e97d08ec6c9a6e3c4254ca6c1ff23926e3c4896f5aacebc16ead2f478db"
  license "Unlicense"
  head "https://github.com/WyattBlue/auto-editor.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d78ba943e77c9a8c0c220946069ee0ddc0dd86465eca706555a89a5ce3211711"
    sha256 cellar: :any, arm64_sequoia: "2291c54f1260f10d7c7a4ce895569801d68a1517955464ec9457779231beafd5"
    sha256 cellar: :any, arm64_sonoma:  "27159e3bf1996e81d11d8e67cbace9fd3a7399fb6b485e80bed78bf992211598"
    sha256 cellar: :any, sonoma:        "0c6ddab78c39809879b56816fe7e744ae7b4feaa3f034fd5ac1a782a01b5e6ca"
    sha256 cellar: :any, arm64_linux:   "35c67ff8ef2adb88c411bcec5eb993f7bfc3d48f417c51edb7da67286cfea6cb"
    sha256 cellar: :any, x86_64_linux:  "4e63a8f672ade0571b1008b4e8d7386530b4058b1aaf31e85cc136c81aac1691"
  end

  depends_on "nim" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "ggml"
  depends_on "whisper-cpp"

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

    whisper = Formula["whisper-cpp"]
    system bin/"auto-editor", "whisper", whisper.pkgshare/"jfk.wav",
      whisper.pkgshare/"for-tests-ggml-tiny.bin"
  end
end
