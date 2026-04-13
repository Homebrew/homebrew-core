class AutoEditor < Formula
  desc "Effort free video editing!"
  homepage "https://auto-editor.com"
  url "https://github.com/WyattBlue/auto-editor/archive/refs/tags/30.1.2.tar.gz"
  sha256 "e0f11de9a443f6c7c2ca59c284d56c1bb9c9ece34bd502511047c89571a9c32e"
  license "Unlicense"
  head "https://github.com/WyattBlue/auto-editor.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8f86adf89f820129ac72e8fc9b7a71a175c3e4702ed494f8ec4648f14ee7f688"
    sha256 cellar: :any,                 arm64_sequoia: "ec852b8bca0f17b8d686c53b8d62aec1d45e7ac17649779937cecc956d53fd01"
    sha256 cellar: :any,                 arm64_sonoma:  "ee940648bd7f191fae03560da76363c8946806679e7447459dadd773733fb71e"
    sha256 cellar: :any,                 sonoma:        "623acdd6d2102fafe94c5c112b01df988db532e926722dec9e2b3edfbc71922a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3fd06208c4037277fb13e22386a9919d1e639a500cf98d503a60e0bd4c06cfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a96b517e4f15b4c218a9ad1a1e2d843e6bf2b7b9fda95633e578e4cb6fcda958"
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
