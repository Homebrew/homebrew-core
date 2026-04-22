class AutoEditor < Formula
  desc "Effort free video editing!"
  homepage "https://auto-editor.com"
  url "https://github.com/WyattBlue/auto-editor/archive/refs/tags/30.1.4.tar.gz"
  sha256 "8acc28560d16fa21692ae19eaefd385cb8bc4ed5dbeb25f76555d75637f844d7"
  license "Unlicense"
  head "https://github.com/WyattBlue/auto-editor.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9546ed767f6f00069cf5d1573a3f0af6f2ec1bf156910b3e739d4851c4a54eef"
    sha256 cellar: :any,                 arm64_sequoia: "da56f88da255722fc94c1176ff694d73730329ad9fe7b4c3afa8e1b974a42029"
    sha256 cellar: :any,                 arm64_sonoma:  "b889261135e37f16d69b97e0135dd1a9b836a64f9a4278631d65ed82aa0d1f07"
    sha256 cellar: :any,                 sonoma:        "92db5039b2987cd86ffc5e565ffbde574460b55d776166d9047a5e62da3f8eec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d84d748208689146f10c127682ceac3dcdafc100ebf2f832cfb4726718f49d83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8641be33bcef9b38b877282d14eb3b26ab76024a4baaffd0b11ceefb22e57f91"
  end

  depends_on "nim" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"

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
  end
end
