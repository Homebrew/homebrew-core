class AutoEditor < Formula
  desc "Effort free video editing!"
  homepage "https://auto-editor.com"
  url "https://github.com/WyattBlue/auto-editor/archive/refs/tags/31.10.0.tar.gz"
  sha256 "cef9031bc610710c076c28a801627ec2e67c52aa495f9273a90787a0adae394c"
  license "Unlicense"
  head "https://github.com/WyattBlue/auto-editor.git", branch: "master"

  bottle do
    manifest_sha256 "7190bfe0928906ac63c234185dd6e74e47744d6fa3a3a8375f225697b215ae7e"
    sha256 cellar: :any, arm64_golden_gate: "b573b47a748bc7e67af43878c355ad29f350cbe39b792c118882261314b7eda6"
    sha256 cellar: :any, arm64_tahoe:       "1c39519221933794d56fc97dbd9752fbb7160235632d0200f8fc928196eac536"
    sha256 cellar: :any, arm64_sequoia:     "7045af73fd043f58024111d20db9a7463ca6bfefae96d7d7b49b4040a1f3e9d9"
    sha256 cellar: :any, arm64_linux:       "32a60aa46746299a1e986e32f9a728aec7da815fb6c2a8e9582427fde91304e2"
    sha256 cellar: :any, x86_64_linux:      "3c0324358916f46e37bb1b953a4e6abe6ea6bbc8b2afe21201188eedb0301245"
  end

  depends_on "nim" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "ggml"
  depends_on "libass"
  depends_on "whisper.cpp"

  resource "homebrew-roboto", :test do
    url "https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxP.ttf"
    sha256 "466989fd178ca6ed13641893b7003e5d6ec36e42c2a816dee71f87b775ea097f"
  end

  deny_network_access!

  def fetch
    system "nimble", "install", "--depsOnly"
  end

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

    resource("homebrew-roboto").stage testpath
    system bin/"auto-editor", mp4in, "--edit", "none", "-w:1",
      "text:Hello:font=#{testpath}/KFOmCnqEu92Fr1Mu4mxP.ttf", "-o", testpath/"text.mp4"
    assert_path_exists testpath/"text.mp4"

    whisper = Formula["whisper.cpp"]
    system bin/"auto-editor", "whisper", whisper.pkgshare/"jfk.wav",
      whisper.pkgshare/"for-tests-ggml-tiny.bin"
  end
end
