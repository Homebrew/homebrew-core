class AutoEditor < Formula
  desc "Effort free video editing!"
  homepage "https://auto-editor.com"
  url "https://github.com/WyattBlue/auto-editor/archive/refs/tags/30.2.0.tar.gz"
  sha256 "d24a53c2e8fb6f9e257950f203468569452b7ba1615770ad04c253f2a73a3649"
  license "Unlicense"
  head "https://github.com/WyattBlue/auto-editor.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "eccb835023b18ccbc0b55b1279bf79a93d1f058c28377f63aae50ebdc38c256b"
    sha256 cellar: :any,                 arm64_sequoia: "fa12e6ce84bddea7dee178244c4c517a8140df3fef7d585e3e88954787da6a1f"
    sha256 cellar: :any,                 arm64_sonoma:  "d4b522f24434cc94923b1c05311a686e4a568db7911e5a1b0ccfb4f251c926d3"
    sha256 cellar: :any,                 sonoma:        "91a36e9f831a7f5024fbb9924d3f38763b1966debec2581c89ba275783281f88"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f22e7e60b53f05ac0d044da6c35f046bc839e3c258ae178b4234ae7d978e415d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4aa4fef50930cc183b85a3453a6fcc7bdcf5892c861e4bdb45e0755ce7fff943"
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
