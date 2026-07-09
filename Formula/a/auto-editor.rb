class AutoEditor < Formula
  desc "Effort free video editing!"
  homepage "https://auto-editor.com"
  url "https://github.com/WyattBlue/auto-editor/archive/refs/tags/31.1.2.tar.gz"
  sha256 "155b594c15c4c0f6ccb822ae2c70089541fb7c516924610ef8fd9c8748416bd1"
  license "Unlicense"
  revision 1
  head "https://github.com/WyattBlue/auto-editor.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "958c8e14f0f72660553d9f49472b4ea3b7133b3b053c15071d87e1ab95798e70"
    sha256 cellar: :any, arm64_sequoia: "507568c03b15a5d601f94205da6ab9c7e38fcf8001ec744b5f10a977ea3f57d5"
    sha256 cellar: :any, arm64_sonoma:  "f2d22a3b077034be11c177db6293f6aef6d3d2340d9ee370afed19aea97b891b"
    sha256 cellar: :any, sonoma:        "2c3ba1e2ef60151991601ab8ebb93217266d21e3f78f2a85058e8e7961852786"
    sha256 cellar: :any, arm64_linux:   "63fe1559ebfcb6e5be359dce9dd7c440adfd7de38ad1e2d6bff7a095bfd52d53"
    sha256 cellar: :any, x86_64_linux:  "1abee32c564e15b89a3295803e135579c76f319dea5b7b8df9d53bb3db24f2e3"
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
