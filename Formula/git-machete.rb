class GitMachete < Formula
  include Language::Python::Virtualenv

  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https://github.com/VirtusLab/git-machete"
  url "https://pypi.org/packages/source/g/git-machete/git-machete-3.16.1.tar.gz"
  sha256 "9688e810c4a75e75aad0886a4180ac78a5c56afe06878f6d21a9cf8fcf8acf9c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ba293dcdf2f3cca6121cd3475ed8bb5d8c9b421d81ca3b14cc45e4dd3b3540e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ba293dcdf2f3cca6121cd3475ed8bb5d8c9b421d81ca3b14cc45e4dd3b3540e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3ba293dcdf2f3cca6121cd3475ed8bb5d8c9b421d81ca3b14cc45e4dd3b3540e"
    sha256 cellar: :any_skip_relocation, ventura:        "5fde1ed23ab7c07da7fd9b222c2b7cc562d6e83c3f7a0620c9e39a7143b9bfc8"
    sha256 cellar: :any_skip_relocation, monterey:       "5fde1ed23ab7c07da7fd9b222c2b7cc562d6e83c3f7a0620c9e39a7143b9bfc8"
    sha256 cellar: :any_skip_relocation, big_sur:        "5fde1ed23ab7c07da7fd9b222c2b7cc562d6e83c3f7a0620c9e39a7143b9bfc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2324406496ea37335bdc6157593bb925846e2570a144c4883b28a8c282cc277"
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
