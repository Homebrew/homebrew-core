class GitMachete < Formula
  include Language::Python::Virtualenv

  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https://github.com/VirtusLab/git-machete"
  url "https://pypi.org/packages/source/g/git-machete/git-machete-3.18.2.tar.gz"
  sha256 "4d8bdde1768c00b9fe6199a2d7fef831491d6fb2e7ed4d56ff3c5b155168b881"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89974d39913baecc43e1f6a6854870f948dd0fd491b1d1d275708029d4b1012b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4511f18b87d27028c287014e84e6701cdcc053899cc9fa6ff7b3dc126691dcf9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "69769bf0c0ebb90b27dbbd87ce1421d5ef4e74db34a2e95fa5fa4e371bd03768"
    sha256 cellar: :any_skip_relocation, ventura:        "8300b112b21b26f66d0c876c34c91863fc9ab9b1062c93bd8b62e10896dc3c01"
    sha256 cellar: :any_skip_relocation, monterey:       "9c00ad7f378dd6f946764ee905f54b0e8ed12ef6a231eea044eabe12ef0842be"
    sha256 cellar: :any_skip_relocation, big_sur:        "af4be101bcc59557c9fbdcd5448af99419aaae5317cb23507f844d0cca7b8e79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed96b43d511e51048d04a3e543aa63632d52f3f52e2a836c9eda53271b4d2188"
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
