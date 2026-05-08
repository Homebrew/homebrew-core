class AutoEditor < Formula
  desc "Effort free video editing!"
  homepage "https://auto-editor.com"
  url "https://github.com/WyattBlue/auto-editor/archive/refs/tags/30.1.6.tar.gz"
  sha256 "c9d3f9efc9ec1bb3b0c930595ae389a25bda35eece6ea5657d1ec5573e80f0bd"
  license "Unlicense"
  head "https://github.com/WyattBlue/auto-editor.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cc168adacecae7293e478cc839cfc376dd1c238332a0dfb4a4b435249a7faab6"
    sha256 cellar: :any,                 arm64_sequoia: "3b2d276498d44e4e64eee19f4cef98bbee38824aee44c4cddba8273da1d0d6a8"
    sha256 cellar: :any,                 arm64_sonoma:  "b2301f91c4cdbaa4679f1db0e3179515458648dd97c47e5396edc315a209e2a8"
    sha256 cellar: :any,                 sonoma:        "3879973e5797641f6e2ba8463d9dd3fcaf564249c60145920ec33aa1c446b8ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83828f9bfb9bfa9cdb918d1fd7faae47b58e77032d36e3548f988a19963243bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41eb2e69b7f6fe2e1aed811d87586dc488dc3ca15e23d2b63d303ce8a77641a8"
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
