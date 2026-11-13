class AutoEditor < Formula
  desc "Effort free video editing!"
  homepage "https://auto-editor.com"
  url "https://github.com/WyattBlue/auto-editor/archive/refs/tags/31.8.0.tar.gz"
  sha256 "045944d594d611d367fafcf78de352483247dc413be86ee2125455119b3685fd"
  license "Unlicense"
  revision 1
  head "https://github.com/WyattBlue/auto-editor.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "855f5d56ae91e0c64c2c28ddd3dc5db1adad4573e292ea08f7062ec7382c40d8"
    sha256 cellar: :any, arm64_tahoe:       "d4de5561c845255065f2a4d14ef59927d447f6f0547c784fc3349a0b925c7ec9"
    sha256 cellar: :any, arm64_sequoia:     "723a526816e14a2632f6b39216fe749c06cde02c0f19d160a77d3b6c0ab3df53"
    sha256 cellar: :any, arm64_linux:       "5143a4746dc43adf1b0c44524fb13cb8b41b8d30ac7690fedb06e22bb4066dbe"
    sha256 cellar: :any, x86_64_linux:      "97674d2bc995d57469c8ea86e063ba248375df5399e4a493ad4a7502379cc54b"
  end

  depends_on "nim" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "ggml"
  depends_on "libass"
  depends_on "whisper.cpp"

  resource "homebrew-roboto", :test do
    url "https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxP.ttf"
    sha256 "466989fd178ca6ed13641893b7003e5d6ec36e42c2a816dee71f87b775ea097f"
  end

  deny_network_access!

  def fetch
    system "nimble", "install", "--depsOnly"
  end

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

    resource("homebrew-roboto").stage testpath
    system bin/"auto-editor", mp4in, "--edit", "none", "-w:1",
      "text:Hello:font=#{testpath}/KFOmCnqEu92Fr1Mu4mxP.ttf", "-o", testpath/"text.mp4"
    assert_path_exists testpath/"text.mp4"

    whisper = Formula["whisper.cpp"]
    system bin/"auto-editor", "whisper", whisper.pkgshare/"jfk.wav",
      whisper.pkgshare/"for-tests-ggml-tiny.bin"
  end
end
