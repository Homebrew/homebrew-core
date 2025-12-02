class AutoEditor < Formula
  desc "Efficient media analysis and rendering"
  homepage "https://auto-editor.com"
  url "https://github.com/WyattBlue/auto-editor/archive/refs/tags/29.3.1.tar.gz"
  sha256 "6cfe85e08f034656b488c2455dc8556a45e585572d544193eeb9635de7230d1e"
  license "Unlicense"
  head "https://github.com/WyattBlue/auto-editor.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d88dd9dffd9f729473eadd4ae42504dca4db8909cac72ac797bd5391313db41f"
    sha256 cellar: :any,                 arm64_sequoia: "2951573d60a912187a20feeb7365e43500e6da6e107c895be512f4f59bf46b00"
    sha256 cellar: :any,                 arm64_sonoma:  "1427c7e919ac17e825fc2ff5d5907f5de607f8bf8b24dd2a3c4f29473a105891"
    sha256 cellar: :any,                 sonoma:        "5e93bc0f2296bcdc6496e99a69a3d30c833104d8e199fbcea1d6305fe7754651"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8aa152a377b112a7e07ee2470c3cd8328187814be62c725538563dcea6cf030e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1038847ce65836fce830d9c981825a7b64b188a3fd86502ac5715862a1b76d89"
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

  on_intel do
    depends_on "nasm" => :build
  end

  def install
    # Install Nim dependencies
    system "nimble", "install", "-y"

    # Build auto-editor
    system "nimble", "make"
    bin.install "auto-editor"
  end

  test do
    mp4in = testpath/"video.mp4"
    mp4out = testpath/"video_ALTERED.mp4"
    system "ffmpeg", "-filter_complex", "testsrc=rate=1:duration=5", mp4in
    system bin/"auto-editor", mp4in, "--edit", "none", "--no-open"
    assert_match(/Duration: 00:00:05\.00,.*Video: h264/m, shell_output("ffprobe -hide_banner #{mp4out} 2>&1"))
  end
end
