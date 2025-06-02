class AbAv1 < Formula
  desc "AV1 re-encoding using ffmpeg, svt-av1 & vmaf"
  homepage "https://github.com/alexheretic/ab-av1"
  url "https://github.com/alexheretic/ab-av1/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "837c3016f6eeca3ea174bdaffcc9bb29cc4917a05f43367579b8b0d7bf68db15"
  license "MIT"
  head "https://github.com/alexheretic/ab-av1.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04715c5f2216854981f06d8ebc2d9727e62a4d620a34a946a6e1220713b345b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb775dec52ea9060ef46dd12fbf69bac19247e9e9f7c1d933a3e719a39e4eb5e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "68be40cbf888318be54384ff4f1d4d06a40f529f15359fa66bdba77aee67dcc8"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ed85f7c2c967b176cd214228871093fccbd06161bf7d5af54714e9205a96fa1"
    sha256 cellar: :any_skip_relocation, ventura:       "ecc784749ec6db65e5486d0273a5a660d69cd5ed754b21e8f0f11b99b66016ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65bcdf53821d56750c86baa264642ad1d24be83d595042d7ca1a9a47260b4ac5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "933c580f775fd196beefa567b76746ba41131ee62678c32c6347c9ca03227bb0"
  end

  depends_on "rust" => :build
  depends_on "ffmpeg"

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"ab-av1", "print-completions", shells: [:bash, :zsh])
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
