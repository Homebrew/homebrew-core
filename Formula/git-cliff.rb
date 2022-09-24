class GitCliff < Formula
  desc "Highly customizable changelog generator"
  homepage "https://github.com/orhun/git-cliff"
  url "https://github.com/orhun/git-cliff/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "86ed2b9e84d062a880f431aec2d7550cedfab4232e76af4398f4cc3b3a487cb9"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1205bf04ef3555a6125a7b2a084b04726c4e25133cc5c172edd18c80c9da24f3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "160daac17909de7afdc5367d3515f6e298c73f819402ca6d360029227fa0fb5f"
    sha256 cellar: :any_skip_relocation, monterey:       "341571044039e1938e71071abc17f8c67aa5c02c5b0b33158c6196dbc2d630a0"
    sha256 cellar: :any_skip_relocation, big_sur:        "4f4011ffb249ff358fe50a9fad61bb985a7e2aa9f05a6230c5fee7549ac7de0d"
    sha256 cellar: :any_skip_relocation, catalina:       "093b3ed43f745e24deff286752914de226e118334ec0b9edff75e9c0d761b2d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3cb2e2ed177a44e158436a648fcd546cc1c421bb71d2f33be16fe3d335695568"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args(path: "git-cliff")

    ENV["OUT_DIR"] = buildpath
    system bin/"git-cliff-completions"
    bash_completion.install "git-cliff.bash"
    fish_completion.install "git-cliff.fish"
    zsh_completion.install "_git-cliff"
  end

  test do
    system "git", "cliff", "--init"
    assert_predicate testpath/"cliff.toml", :exist?

    system "git", "init"
    system "git", "add", "cliff.toml"
    system "git", "commit", "-m", "chore: initial commit"
    changelog = "### Miscellaneous Tasks\n\n- Initial commit"
    assert_match changelog, shell_output("git cliff")
  end
end
