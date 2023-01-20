class GitCliff < Formula
  desc "Highly customizable changelog generator"
  homepage "https://github.com/orhun/git-cliff"
  url "https://github.com/orhun/git-cliff/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "26f05e4cfea07768d06ae92cd4b34bae786ed354089d9b5b1659d6408bf583c6"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c4abd35e4a79976ef998879783ae11f9b2c8387a14c49e9a8c935dd84c2d8df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "320a7e15bf2e13f16a9d00b21401516057deba100894fa96a17fd921b7773ba6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0cfe825963d5af102f8974aaff4943a4f590fbdb2c3c7119247b111d3a3ed3db"
    sha256 cellar: :any_skip_relocation, ventura:        "6ac44b2b9d855289e27c27acd20c286c429cd5aa3b1ca54a95ac931a9c044904"
    sha256 cellar: :any_skip_relocation, monterey:       "e3033fa65d4cdc8c72b623dbac5153d658c1902206183c1210f3641c20d69cd8"
    sha256 cellar: :any_skip_relocation, big_sur:        "cec4349ef93d01339c9a80ac8feb3d9e50c8a5d5f03a1195bfff0ee57ea8e551"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb74adcdbc515f6c5ed168805e7298d5e782972a48738abe20c796673d5c98de"
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
