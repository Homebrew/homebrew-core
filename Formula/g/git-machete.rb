class GitMachete < Formula
  include Language::Python::Virtualenv

  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https://github.com/VirtusLab/git-machete"
  url "https://files.pythonhosted.org/packages/8d/17/d3e701496c600b903060986a662994c38279cf6a4e3e08b6d193de263938/git-machete-3.23.2.tar.gz"
  sha256 "2766b677bae7f2f7dc596ff6dcc7b6bcc06bc8e3c75a4ca8d826de5619cbc406"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "da0bd409bf214a61c6f7e1db5ff67cfb0f89adf9ea489282b76bf3c4801779f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "528cb96ca908938e9e2e75a265f7fdf0c1a42008f98074f831ea517a4471ddc7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "585c3357ef871ee9cf18af8d839a9bc65e1ff5563921836785f5c50b98562e80"
    sha256 cellar: :any_skip_relocation, sonoma:         "d739aa668af28e61b5d1860290eb0be9bac6d26957d44574b241a5bd4dbf2328"
    sha256 cellar: :any_skip_relocation, ventura:        "b34d9f70042f41f3cecfd6e79ccc52735235db60dc836f6e81d33ae44bca3ac6"
    sha256 cellar: :any_skip_relocation, monterey:       "fc085b6511a8e43a333c2b94f69dc18748e94b7f6a2b28072d2f985efef7c686"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db6558916c4320d13e9bee0619ec3a6fded202f49527cecc648fb030f471b6d6"
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
