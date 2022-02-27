class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  url "https://github.com/sharkdp/bat/archive/v0.20.0.tar.gz"
  sha256 "12eca3add56f21b8056a4c17cfb5bffc45e107f23f75a8e0f5de948d8e997c39"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7a442b570f36e440439949f7daecd98e2dd5b31efe729f541e8da48ca9ec0ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "add86eb8edf0b45685eac681556c3661e5b77d1871ad48e6ee01377702927f43"
    sha256 cellar: :any_skip_relocation, monterey:       "8da409d52a66eac1b58ed880136231eb7bfc51ea539a7fa07b7b111838876a25"
    sha256 cellar: :any_skip_relocation, big_sur:        "c7e91069fc195b658d2ac89d219af3b6ed0bdd740b70f335d2851620cc874042"
    sha256 cellar: :any_skip_relocation, catalina:       "00f4fc7d8443630cdbd4fcd4d4fb89264a5176354331b8b10cf631db63cd1cb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8db3c6972d8c52701bf8cc0fabf418735da83ce6caef3737f1714f0d68fd7fd1"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", *std_cargo_args

    assets_dir = Dir["target/release/build/bat-*/out/assets"].first
    man1.install "#{assets_dir}/manual/bat.1"
    bash_completion.install "#{assets_dir}/completions/bat.bash" => "bat"
    fish_completion.install "#{assets_dir}/completions/bat.fish"
    zsh_completion.install "#{assets_dir}/completions/bat.zsh" => "_bat"
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/bat #{pdf} --color=never")
    assert_match "Homebrew test", output
  end
end
