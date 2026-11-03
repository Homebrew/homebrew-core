class AutoEditor < Formula
  desc "Effort free video editing!"
  homepage "https://auto-editor.com"
  url "https://github.com/WyattBlue/auto-editor/archive/refs/tags/31.8.0.tar.gz"
  sha256 "045944d594d611d367fafcf78de352483247dc413be86ee2125455119b3685fd"
  license "Unlicense"
  head "https://github.com/WyattBlue/auto-editor.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "10f4afe8f03ef549303677731b586a045a4f61acc50a067ddefff79d8ed8d6d3"
    sha256 cellar: :any, arm64_tahoe:       "d04bb5ff2d12bc0e69a4adb8991a7b255e003d1921dd47df2bc495b2da195ca6"
    sha256 cellar: :any, arm64_sequoia:     "17242bfe49135c0780e80934cca883fa04c3a6f76026ef254f5e67d7ccb6f883"
    sha256 cellar: :any, arm64_linux:       "f0e4382c1ffd03d78fefdd40df217c88c9815fd309a7fc7bb41b8ac667fd24d1"
    sha256 cellar: :any, x86_64_linux:      "e91468b88e3e5b3043c3381839be079fd10f5270cf80afa45bba41d05573eb97"
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
