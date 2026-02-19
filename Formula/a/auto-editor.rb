class AutoEditor < Formula
  desc "Effort free video editing!"
  homepage "https://auto-editor.com"
  url "https://github.com/WyattBlue/auto-editor/archive/refs/tags/29.7.0.tar.gz"
  sha256 "0e400bebeb50745cb42396b93b4503272db6f7d72e85d5d6829d524fab8bb403"
  license "Unlicense"
  revision 1
  head "https://github.com/WyattBlue/auto-editor.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ea1e27df3d612289baa3d646333221c1cb05aa842cea256951f715d8259348a7"
    sha256 cellar: :any,                 arm64_sequoia: "763dde3bf23c3f47ca9ed6bc753b3c1a8071c0ffebce5d4e875229d380e7d1d5"
    sha256 cellar: :any,                 arm64_sonoma:  "7cf297b2c910d4239bf79c18f26d48d405878ead63a0c7e0474dae9ada2d2b58"
    sha256 cellar: :any,                 sonoma:        "17e3303a9a7999e341f679d281cd6b0bec9ff545e29c2f2399e38271c52cd7ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ebd41180014e066cccdb9544ede9b3688e514fb258f408ea93f78f2a208eff0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78707c8330b5341eb1776955852cabb072f10cd4023c5a4401ffa95127f0348e"
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
    generate_completions_from_executable("nimble", "zshcomplete", "--silent", shells: [:zsh])
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
