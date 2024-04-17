class GitMachete < Formula
  include Language::Python::Virtualenv

  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https://github.com/VirtusLab/git-machete"
  url "https://pypi.org/packages/source/g/git-machete/git-machete-3.25.0.tar.gz"
  sha256 "ab838e144849124369cbd136dec90cf22e9fa49a9927018d2c2e40d5a501d7c2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "359f4094718752d4c937c3a6a766002749c59b00aa4805881d4a320450379e58"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "359f4094718752d4c937c3a6a766002749c59b00aa4805881d4a320450379e58"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "359f4094718752d4c937c3a6a766002749c59b00aa4805881d4a320450379e58"
    sha256 cellar: :any_skip_relocation, sonoma:         "359f4094718752d4c937c3a6a766002749c59b00aa4805881d4a320450379e58"
    sha256 cellar: :any_skip_relocation, ventura:        "359f4094718752d4c937c3a6a766002749c59b00aa4805881d4a320450379e58"
    sha256 cellar: :any_skip_relocation, monterey:       "359f4094718752d4c937c3a6a766002749c59b00aa4805881d4a320450379e58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d6124e2a53a96c793bb38801699a2c71aac26af778fcb6f56d352a3163cddfb"
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
