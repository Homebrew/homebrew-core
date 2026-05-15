class Asak < Formula
  desc "Cross-platform audio recording/playback CLI tool with TUI"
  homepage "https://github.com/chaosprint/asak"
  url "https://github.com/chaosprint/asak/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "d4df734e87b63cf20f7fa34e15853afa640620043871497d54f78a6818680dd6"
  license "MIT"
  head "https://github.com/chaosprint/asak.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ece34a9219e864c87ba8cb21d120dc79100df2bde873715f5fa45401b7af0548"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1aeb82e44bd338080df9218164db8ce26330b5f4c89269d45a8f16147757602f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12c898a0f70d04045e16592e024ecfecaf95cdccab6955dbfcef95682db3402f"
    sha256 cellar: :any_skip_relocation, sonoma:        "07a5c1fe0e9ffa353f3240484eabf614f041b8bd53884b9f7e6df15dd535d451"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46d875061b821be6723665dd5774716325b901e54853b27c77683236581f456b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "366d64c0c14529791b97ae92dc89b3c5a2343c167874586aecb69054eadf184d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "jack"

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "target/completions/asak.bash" => "asak"
    fish_completion.install "target/completions/asak.fish"
    zsh_completion.install "target/completions/_asak" => "_asak"
    man1.install "target/man/asak.1"
  end

  test do
    output = shell_output("#{bin}/asak play 2>&1", 2)
    assert_match "unexpected argument 'play' found", output

    assert_match version.to_s, shell_output("#{bin}/asak --version")
  end
end
