class GitMachete < Formula
  include Language::Python::Virtualenv

  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https://github.com/VirtusLab/git-machete"
  url "https://pypi.org/packages/source/g/git-machete/git-machete-3.14.0.tar.gz"
  sha256 "1491aa88b6b5ef3a21cfc1456c115ab83e4675dd19dfc9e333126a880d1852a0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80e2b303bfc8862e9bf465db708d366b9e5426c4db5f360abd36de11ec3c1104"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80e2b303bfc8862e9bf465db708d366b9e5426c4db5f360abd36de11ec3c1104"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "80e2b303bfc8862e9bf465db708d366b9e5426c4db5f360abd36de11ec3c1104"
    sha256 cellar: :any_skip_relocation, ventura:        "bd7bd3c5f7a39dfa3a0fb367ab627ccfab68e595bbc15abc3a1a6c0898a67358"
    sha256 cellar: :any_skip_relocation, monterey:       "bd7bd3c5f7a39dfa3a0fb367ab627ccfab68e595bbc15abc3a1a6c0898a67358"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd7bd3c5f7a39dfa3a0fb367ab627ccfab68e595bbc15abc3a1a6c0898a67358"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42b755274ace35c97a2ec927266834626339c068519ccca2df85621ca20b89bf"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources

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
