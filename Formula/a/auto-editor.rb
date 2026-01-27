class AutoEditor < Formula
  desc "Effort free video editing!"
  homepage "https://auto-editor.com"
  url "https://github.com/WyattBlue/auto-editor/archive/refs/tags/29.6.2.tar.gz"
  sha256 "71144d2deb1796ba289853507d15e74a45099d250d606eba2d6d8e3aaf3ed6a1"
  license "Unlicense"
  revision 1
  head "https://github.com/WyattBlue/auto-editor.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0b9c9e0669e62b122557ed985dee9524a023697708ca9cceb02c2200731240ac"
    sha256 cellar: :any,                 arm64_sequoia: "2de38428b4047e204289dae1c3d143a4a378228b03a83a0b2350b97b37f74a4b"
    sha256 cellar: :any,                 arm64_sonoma:  "a8da6938c000bd0c9370bb73a4f85bb483d7308dc2b17c675c6f1c98f3f9fa50"
    sha256 cellar: :any,                 sonoma:        "9d789b2940bfd79902e73167597dcf44ac9092e2bd36a71939db5790ade10027"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f996d39ca5b186b2b429ab08ef7888ca1010c934de574e0332dc5956f9559b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22dc08f58ddf72b513648660d38991d6fe1011c8cf92027cc63889aad67514b7"
  end

  depends_on "nim" => :build
  depends_on "pkgconf" => :build
  depends_on "dav1d"
  depends_on "ffmpeg-full"
  depends_on "lame"
  depends_on "libvpx"
  depends_on "llama.cpp"
  depends_on "opus"
  depends_on "svt-av1"
  depends_on "whisper-cpp"
  depends_on "x264"
  depends_on "x265"

  def install
    ENV["DISABLE_VPL"] = "1"
    system "nimble", "make"
    generate_completions_from_executable("nimble", "zshcomplete", "--silent", shells: [:zsh])
    bin.install "auto-editor"
  end

  test do
    ENV.prepend_path "PATH", Formula["ffmpeg-full"].bin
    mp4in = testpath/"video.mp4"
    mp4out = testpath/"video_ALTERED.mp4"
    system "ffmpeg", "-filter_complex", "testsrc=rate=1:duration=5", mp4in
    system bin/"auto-editor", mp4in, "--edit", "none", "--no-open"
    assert_match(/Duration: 00:00:05\.00,.*Video: h264/m, shell_output("ffprobe -hide_banner #{mp4out} 2>&1"))
  end
end
