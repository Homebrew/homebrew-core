class AutoEditor < Formula
  desc "Effort free video editing!"
  homepage "https://auto-editor.com"
  url "https://github.com/WyattBlue/auto-editor/archive/refs/tags/31.9.0.tar.gz"
  sha256 "4e17be20d523878a33b64fa1c9876e9b200a7740bd66f63b0db16e7c9da9896d"
  license "Unlicense"
  head "https://github.com/WyattBlue/auto-editor.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "86b42df5e9f7b7092eca5a88887686a9be6974afb4bcf73bd7b5a3e093e2e892"
    sha256 cellar: :any, arm64_tahoe:       "85d637867e5adc60c85174cbd2949aa3b86360273bdf468134bed1eabd0ea030"
    sha256 cellar: :any, arm64_sequoia:     "c3bd19946d45e7f29e0d5364c8ae0e5e852437f456186b6324c0ddbe2b19e916"
    sha256 cellar: :any, arm64_linux:       "52543f54e616b3589f2d607c9b1dac09163bfc4c0ec04680f10ebcab731baaa7"
    sha256 cellar: :any, x86_64_linux:      "b65e6223d1e5deb4548c8443949bdb556562ecf55aa051a35beafe69110ceb4a"
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
