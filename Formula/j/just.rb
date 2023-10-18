class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/1.15.0.tar.gz"
  sha256 "a3d183c9be9d67d746ae3ace2c29b378c9afb9e564b73f1cff6e6cd1a03eed4a"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "58d914355e3e51d2fb870447cec76d57840be64a5a274401a1c5cd29adb47c25"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2d2336c02e5d43957a57767b5b9e710cd7af4ac54a2c95efb16024f92980f72"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fdc677c80052003bdbaf75a6a0e60e462f268ceb83d8211403ea525b97953688"
    sha256 cellar: :any_skip_relocation, sonoma:         "73a43b45568cfeede4e57311cc7b994eebfe485099d1b0f1e7759a60022cef87"
    sha256 cellar: :any_skip_relocation, ventura:        "7599c4f24653e72576df09f8a0ff85029d6c28a65351a6d0396758560da99866"
    sha256 cellar: :any_skip_relocation, monterey:       "a4b3ebcc10c3b3f3bded7f29e1f394a1ecf911213ad08eb3eb70c278548ca4b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f060d434017bbce5fb871a482563e772d3e58a9efcd2648fbd3ca7477cd04d7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    man1.install "man/just.1"
    bash_completion.install "completions/just.bash" => "just"
    fish_completion.install "completions/just.fish"
    zsh_completion.install "completions/just.zsh" => "_just"
  end

  test do
    (testpath/"justfile").write <<~EOS
      default:
        touch it-worked
    EOS
    system bin/"just"
    assert_predicate testpath/"it-worked", :exist?
  end
end
