class AutoEditor < Formula
  desc "Efficient media analysis and rendering"
  homepage "https://auto-editor.com"
  url "https://github.com/WyattBlue/auto-editor/archive/refs/tags/29.6.0.tar.gz"
  sha256 "fa212ea93f114b7dfe8b196b9c68055e8123cdeda296560500b9ad384e120dee"
  license "Unlicense"
  head "https://github.com/WyattBlue/auto-editor.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "88e512d1b4ecae3e816cda074ad211126f6466f50ba8be187044ca2480cab3a6"
    sha256 cellar: :any,                 arm64_sequoia: "024ff554b046c699776c26fddfd6ad4d8377e208ff714891c9c02019c4c5e963"
    sha256 cellar: :any,                 arm64_sonoma:  "7408bb07452d7ec7a56991d0025909f233d65090ca76be4ca6067dffbb8da94c"
    sha256 cellar: :any,                 sonoma:        "74f4eaab1a2feee8b8219851659a8152dad5d997f041090ddf5b7a2a4d89b57a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4cfb31c8c548e3743af323fd85d3838f69d15718a48ffa76c7a075c050d56950"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1ce758b579948e962ee2eb4f053961c3d8a42ef3723fce97a0b79e1835cdaec"
  end

  depends_on "nim" => :build
  depends_on "pkgconf" => :build
  depends_on "dav1d"
  depends_on "ffmpeg"
  depends_on "lame"
  depends_on "libvpx"
  depends_on "llama.cpp"
  depends_on "opus"
  depends_on "svt-av1"
  depends_on "whisper-cpp"
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
