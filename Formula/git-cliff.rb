class GitCliff < Formula
  desc "Highly customizable changelog generator"
  homepage "https://github.com/orhun/git-cliff"
  url "https://github.com/orhun/git-cliff/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "98bdf069714bb9f6c82d3aff0199178ac06c0063ddcd82b3e17127fbd4c465e3"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "806d48dcb3356bfb88e6770f4505adde46a7ab2ba0f9e2b1ad0b08be9719e1fd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bdcb5dce5b04237d5c6d23070279a1071f2af3021e528e868b852e7fbae97691"
    sha256 cellar: :any_skip_relocation, monterey:       "e15389706af8df6727f7f79b8f674a5d237c53c74875017dcd2588ee0f613241"
    sha256 cellar: :any_skip_relocation, big_sur:        "19482d057ed553d5df9ea59fae013a1c6b3d55fa500daf1bd48a64e4b7fa2ccd"
    sha256 cellar: :any_skip_relocation, catalina:       "4386cb28d141800f7a7811d0bf7c4872ea2cbab7bfceb3d3a8439c9ecaf539f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fa78430531d7d0f7f124fa90a1d694eb692e19f79bff969d32e4853d94e57ad"
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
