class AutoEditor < Formula
  desc "Effort free video editing!"
  homepage "https://auto-editor.com"
  url "https://github.com/WyattBlue/auto-editor/archive/refs/tags/31.5.0.tar.gz"
  sha256 "c2e2328d38f54428f9efde76e2e3f51716e82b34ffb3d75337e0826fa08d4e1e"
  license "Unlicense"
  head "https://github.com/WyattBlue/auto-editor.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a67fe98e1592de90fb9e5e9df84ffa5309fb2a401530f3ad05f3b5094f636027"
    sha256 cellar: :any, arm64_sequoia: "92e733bb0e13c189164da633c92e1c8a8a401cbe75e4f28bce3c012fbb1cf0a6"
    sha256 cellar: :any, arm64_sonoma:  "ed8c96632687ac7bfaefbeddc5b6aba6102c44c7c4961f6a4e601c5906923414"
    sha256 cellar: :any, sonoma:        "4ccb34a72c7137ae8d7df12cc8393dad9d083fe7faac10581bef3b913f169dec"
    sha256 cellar: :any, arm64_linux:   "0dbcf5e380bcdab7144da792f838bfd031ccfc52a8a034800cbfc292bd7b7745"
    sha256 cellar: :any, x86_64_linux:  "96873d7b907125846b130598bc006e89ce6c90a794e1a75a387095d1b3dce9a9"
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
