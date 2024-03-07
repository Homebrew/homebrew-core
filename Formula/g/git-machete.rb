class GitMachete < Formula
  include Language::Python::Virtualenv

  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https://github.com/VirtusLab/git-machete"
  url "https://files.pythonhosted.org/packages/8d/17/d3e701496c600b903060986a662994c38279cf6a4e3e08b6d193de263938/git-machete-3.23.2.tar.gz"
  sha256 "2766b677bae7f2f7dc596ff6dcc7b6bcc06bc8e3c75a4ca8d826de5619cbc406"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fb83b6ec46bd640ad95007fbc09c719b079b4e0c3417a3ed055e011da1fec27c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "168ec6a9509525370ba4d394bbbe6b9135c4180ea81f2dcd741d6318795fe8f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ece6ddb23f84877b3c522b79d05d28456849de3d5ce6e0dd530486652279de3f"
    sha256 cellar: :any_skip_relocation, sonoma:         "35f8aeca23edecea0cc76d476c709bd37e5c6fcd2dcee7a2281a371b0711384c"
    sha256 cellar: :any_skip_relocation, ventura:        "261ae4a79a770cabd5ebcdfa2e072cc52dc0a215b20f0f60e5eab13a907cfaf3"
    sha256 cellar: :any_skip_relocation, monterey:       "9e3a3824ff18d218a986511d433120c2b99618fd3b177c9e16a7e5c45da09d50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68f3f721d654d8117fbb75f7cec2961a02e4d4301e9cd6a0ffda57f10abb5565"
  end

  depends_on "python@3.12"

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
