class AutoEditor < Formula
  desc "Effort free video editing!"
  homepage "https://auto-editor.com"
  url "https://github.com/WyattBlue/auto-editor/archive/refs/tags/30.4.0.tar.gz"
  sha256 "6dfc7618b2895a5ffc0f0f04994f998b76e57690e88ea68950d7812a4c0926d5"
  license "Unlicense"
  head "https://github.com/WyattBlue/auto-editor.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6b7a802ed2d0b36dd69e6f67e2842748b260237fe112811c732ba6c7fb2be19f"
    sha256 cellar: :any, arm64_sequoia: "f8e9faaef767b7c2dadcee7086901ad3c628170d75d372f4e664f4a42b889220"
    sha256 cellar: :any, arm64_sonoma:  "80c83edb756ea922e361c7a220003d2f46d9506de3d58ec32f5693aae43c178a"
    sha256 cellar: :any, sonoma:        "3c75adf49d7d2b9c960deabec188542e3154bcb7c338665266d5f61c6203460c"
    sha256 cellar: :any, arm64_linux:   "b7f35229ac37e4bd3f7f4f88cf8938958e696eb7ae456b6d4051642558681ec1"
    sha256 cellar: :any, x86_64_linux:  "e7820e9c0e8da9864d60f526838d99227e8bebaf1fbc1b0eee717461e5593fc3"
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
