class AutoEditor < Formula
  desc "Effort free video editing!"
  homepage "https://auto-editor.com"
  url "https://github.com/WyattBlue/auto-editor/archive/refs/tags/30.1.0.tar.gz"
  sha256 "75fb7e9bebaaea5b646555d6352449011a69f8bfbba0d8b54e40410f6bfca3fe"
  license "Unlicense"
  head "https://github.com/WyattBlue/auto-editor.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6ab4a6eb21a40173166d9b18c1236af5c38e9da87c4eb4f1e7ed1bc1fb025a32"
    sha256 cellar: :any,                 arm64_sequoia: "a732ff45764e6dcf61dd307a41889087678c30e2e58daab7a3a83c498b25affc"
    sha256 cellar: :any,                 arm64_sonoma:  "f57cf13d2bdd1ac62d64946375ced35a4cbd5bcb5fc7894381e9b324a1c96a96"
    sha256 cellar: :any,                 sonoma:        "8c02df206c2009bccad8226bda7897113ef1ac376464149004aa032b7e61186f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "563a0aa5271ed95d0adbbdd65b91fc1143e40046da0d77ce993170aa3b3d78bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9243fa2e2273207a4d434806a350b34b5389b7beece5b3dd099c553f0ff65bb7"
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
