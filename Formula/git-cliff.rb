class GitCliff < Formula
  desc "Highly customizable changelog generator"
  homepage "https://github.com/orhun/git-cliff"
  url "https://github.com/orhun/git-cliff/archive/v0.4.2.tar.gz"
  sha256 "9f0c6e59970b39d633c94c804e979e227fed5b7d95b6c59352923aa92cdc67a7"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5433f52e08fea7946476d07185849e06fdda559dddbb0e3e6767578ab90c333"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8b08d87353e0d35b99980f5db8c050479435d5b7b210e8e0e271c625f09ef495"
    sha256 cellar: :any_skip_relocation, monterey:       "ca6a4ce12236f26886289cbb09c6924c3eded7800656c463d5047c71288741ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "fdcc011cdffdf898d70d91b5125eebef1306ddb9ccc3340f01f185739769768d"
    sha256 cellar: :any_skip_relocation, catalina:       "a889c33457e72fcbceed895bac84e6a98fcc044a09148118fa05e2feef8bfe38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa408d660defc1dcf26d4fb9109c785749e1d11023c87f09ac20ded15c8a81de"
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
