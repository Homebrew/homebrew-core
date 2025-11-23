class AbAv1 < Formula
  desc "AV1 re-encoding using ffmpeg, svt-av1 & vmaf"
  homepage "https://github.com/alexheretic/ab-av1"
  url "https://github.com/alexheretic/ab-av1/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "933024405569e0f120db2a78dbfb3488553765d69ae43d99cba8eda64c7886c6"
  license "MIT"
  head "https://github.com/alexheretic/ab-av1.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d019ffabc139b763fb4e8a3dd11279748958d9a49fedd0a64398e2a179d8871a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d7391b2535eb33fc587262239710ff7549dcdf1b422b8b2d7d7c70c73a636f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55a091d085a37ce3f574562bbe662011973c882c09ddbb94fd5e00ada5d4b1ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "080f3ea6f48d63299082cae0a8f6c9b555ad664b22ce1acbc608f7514f1b3cbe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed89b8e177ca5f30a976449ac7c7dffd7707993a6d248338cfed241c6e86a94a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de175d0291703d8e2ade974a3ea98f243e019845954cd88bca4a36da8a3e48a5"
  end

  depends_on "rust" => :build
  depends_on "ffmpeg"

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"ab-av1", "print-completions")
  end

  test do
    resource "sample-mp4" do
      url "https://download.samplelib.com/mp4/sample-5s.mp4"
      sha256 "05bd857af7f70bf51b6aac1144046973bf3325c9101a554bc27dc9607dbbd8f5"
    end

    assert_match "ab-av1 #{version}", shell_output("#{bin}/ab-av1 --version")

    resource("sample-mp4").stage testpath
    system bin/"ab-av1", "auto-encode", "-i", testpath/"sample-5s.mp4"
    assert_path_exists testpath/"sample-5s.av1.mp4"
  end
end
