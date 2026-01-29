class AutoEditor < Formula
  desc "Effort free video editing!"
  homepage "https://auto-editor.com"
  url "https://github.com/WyattBlue/auto-editor/archive/refs/tags/29.6.2.tar.gz"
  sha256 "71144d2deb1796ba289853507d15e74a45099d250d606eba2d6d8e3aaf3ed6a1"
  license "Unlicense"
  revision 1
  head "https://github.com/WyattBlue/auto-editor.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "85933df5bf14f3485c41425a68d07e1f093f001176b86faf19e7c6c6318bf9cd"
    sha256 cellar: :any,                 arm64_sequoia: "41ba20cc7431a8c899e7294a209d13ccc33dd5dc94b21bb479185e3213c27c0f"
    sha256 cellar: :any,                 arm64_sonoma:  "8578eb90c12cbb1ffddba3f38bce01949fc91de0dfc4e3cf4159c41cd98071b7"
    sha256 cellar: :any,                 sonoma:        "19e534f5a2a204749d513095b3f7db7e1ddd8dfadec59a9a0c9c351f26414c39"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff8ad76c0714c482857e1dd8e599fd8c6d7a41c81cbfd702c52c0cc271a754da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc3e53a1011284d2b9818faeb7542381fd43e2c4b8380d75f4cff351f0e68324"
  end

  depends_on "nim" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg-full" # Assumes whisper-cpp, x265, x264, svt-av1, opus, lame, etc. is built
  depends_on "llama.cpp" # For whisper-cpp (Should it be bundled by default?)

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
