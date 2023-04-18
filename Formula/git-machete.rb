class GitMachete < Formula
  include Language::Python::Virtualenv

  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https://github.com/VirtusLab/git-machete"
  url "https://pypi.org/packages/source/g/git-machete/git-machete-3.17.0.tar.gz"
  sha256 "882c6e6ce04cf1123c8c65ed3799b65a97d977d4677378370514a048bb149c49"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c187b3a2a21876e1b94c415a6f3b5136e9323a40b96c38ff410db6f715babdec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c187b3a2a21876e1b94c415a6f3b5136e9323a40b96c38ff410db6f715babdec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c187b3a2a21876e1b94c415a6f3b5136e9323a40b96c38ff410db6f715babdec"
    sha256 cellar: :any_skip_relocation, ventura:        "44f7ed08dc9fe97bb033b39a47167936465aad86934304844baaf4354dd4cdaa"
    sha256 cellar: :any_skip_relocation, monterey:       "44f7ed08dc9fe97bb033b39a47167936465aad86934304844baaf4354dd4cdaa"
    sha256 cellar: :any_skip_relocation, big_sur:        "44f7ed08dc9fe97bb033b39a47167936465aad86934304844baaf4354dd4cdaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b1f6c7663a040bc9db15bbd34694ed0012d4dff8a6f431932991a066de00048"
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
