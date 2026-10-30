class AutoEditor < Formula
  desc "Effort free video editing!"
  homepage "https://auto-editor.com"
  url "https://github.com/WyattBlue/auto-editor/archive/refs/tags/31.8.0.tar.gz"
  sha256 "045944d594d611d367fafcf78de352483247dc413be86ee2125455119b3685fd"
  license "Unlicense"
  revision 1
  head "https://github.com/WyattBlue/auto-editor.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d363f0788383d2979218190a57571feeb5a52cb0993a66ccdb23500857e4e00d"
    sha256 cellar: :any, arm64_tahoe:       "b0755c556d971829d1580c30d36f4a0eb30b4d52f05b0cd85d7bd5d33da2401b"
    sha256 cellar: :any, arm64_sequoia:     "fd580bcef4826b0cf80bfdae4f90ce747424b07efb39ba56c6f26124a3222214"
    sha256 cellar: :any, arm64_linux:       "a4e54e40c0ae8d7df138d46dcf773f5223f6a5902fc7af3f44deb7742ff71539"
    sha256 cellar: :any, x86_64_linux:      "0655032995aae3105136b0aa1e090fdec76bd22087cef5757d0f7319dae4e5da"
  end

  depends_on "nim" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "ggml"
  depends_on "libass"
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

    # Linux builds need a font file given to draw text
    if OS.mac?
      system bin/"auto-editor", mp4in, "--edit", "none", "--when-normal", "text:Hello", "-o", testpath/"text.mp4"
      assert_path_exists testpath/"text.mp4"
    end

    whisper = Formula["whisper.cpp"]
    system bin/"auto-editor", "whisper", whisper.pkgshare/"jfk.wav",
      whisper.pkgshare/"for-tests-ggml-tiny.bin"
  end
end
