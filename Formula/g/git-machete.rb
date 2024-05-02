class GitMachete < Formula
  include Language::Python::Virtualenv

  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https://github.com/VirtusLab/git-machete"
  url "https://files.pythonhosted.org/packages/19/07/c0cac2f6a93ad3f1db398cdce554ad66bff7b0710ea6736ed9d0a16725ed/git_machete-3.25.2.tar.gz"
  sha256 "ef554565ff813c6402cfff7ca3655c620bc44d0dd219992e6c957fe73077da5f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7866dd6b01a39de8a73c8718d97b0ded021bf47b2d6209169fbb26edbd23c1f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7866dd6b01a39de8a73c8718d97b0ded021bf47b2d6209169fbb26edbd23c1f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7866dd6b01a39de8a73c8718d97b0ded021bf47b2d6209169fbb26edbd23c1f0"
    sha256 cellar: :any_skip_relocation, sonoma:         "7866dd6b01a39de8a73c8718d97b0ded021bf47b2d6209169fbb26edbd23c1f0"
    sha256 cellar: :any_skip_relocation, ventura:        "7866dd6b01a39de8a73c8718d97b0ded021bf47b2d6209169fbb26edbd23c1f0"
    sha256 cellar: :any_skip_relocation, monterey:       "7866dd6b01a39de8a73c8718d97b0ded021bf47b2d6209169fbb26edbd23c1f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afd5a556df482fd32af36a3871f9b357e2a7306f72203963c00be5a2c1a3b17b"
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
