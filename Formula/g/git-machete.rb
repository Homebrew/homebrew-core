class GitMachete < Formula
  include Language::Python::Virtualenv

  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https://github.com/VirtusLab/git-machete"
  url "https://pypi.org/packages/source/g/git-machete/git-machete-3.18.3.tar.gz"
  sha256 "b15b9abae64595aee80687ef5a76304a4eae10cd36499b95b7308777594484df"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0cfa11606b97f95f2a9d60007dc09bee24cb4285b3e8511a855a2ecffabfe51"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18671e9c3df07986f25a8d23195d6b9e489a48ebf5160d790427a22aeddfc944"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "788fd83484d5d2b8a202fe9adcae1f4e38aecafae709dc56b2623d221e0dd184"
    sha256 cellar: :any_skip_relocation, ventura:        "705e75f2dbf4f09861891f3bab78c27a2cba668404b0874efb30286c15257c56"
    sha256 cellar: :any_skip_relocation, monterey:       "04f1d9d0b4ddfdc55c5eff6c00c4028fb5259ed37eeb14a38e8156ff18c2dfe2"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce81f35b2a1ba406b3e630428ebcd69598766d59db9811ac719835e619da6e80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6b096e7102173b4e014e61d9fb564f483da0f270ce9bb46986ca067b86f776d"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources

    man1.install "docs/man/git-machete.1"

    bash_completion.install "completion/git-machete.completion.bash"
    zsh_completion.install "completion/git-machete.completion.zsh"
    fish_completion.install "completion/git-machete.fish"
  end

  test do
    system "git", "init"
    system "git", "config", "user.email", "you@example.com"
    system "git", "config", "user.name", "Your Name"
    (testpath/"test").write "foo"
    system "git", "add", "test"
    system "git", "commit", "--message", "Initial commit"
    system "git", "branch", "-m", "main"
    system "git", "checkout", "-b", "develop"
    (testpath/"test2").write "bar"
    system "git", "add", "test2"
    system "git", "commit", "--message", "Other commit"

    (testpath/".git/machete").write "main\n  develop"
    expected_output = "  main\n  |\n  | Other commit\n  o-develop *\n"
    assert_equal expected_output, shell_output("git machete status --list-commits")
  end
end
