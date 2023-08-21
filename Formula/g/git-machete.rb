class GitMachete < Formula
  include Language::Python::Virtualenv

  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https://github.com/VirtusLab/git-machete"
  url "https://pypi.org/packages/source/g/git-machete/git-machete-3.18.0.tar.gz"
  sha256 "e056cf4e76cc5732b06494ae04bf94ac7ad018264a519a16e34b11379d66dbf7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d41f2fadbb59b020a58885e5139e7719f3c2d7918734f0258fde9b428971e6d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7be947ff8cb7ebcd850d14b06fac8e7f7497be32f79a699ce3c12ea651587810"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "13688091557de678eb712482f88b903bc5321a0c16dc49d891b1ecf805c27501"
    sha256 cellar: :any_skip_relocation, ventura:        "b98f4b018625142f8d4f2b70db6128a3dbae2d6ff3c1c5784c91e71890c0a1d3"
    sha256 cellar: :any_skip_relocation, monterey:       "16e2481a17c984b52f04ae70efc4dfeaa4761c9e5f281298c81f60f4f74a9b18"
    sha256 cellar: :any_skip_relocation, big_sur:        "72139b717ae926f193427d091c7e957053855688f2fcfc37c4f50696b6c5e757"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f674be219ce58541fd0286a5b0845050c28e1d2f95d75eacfe8e223b7e5a70f7"
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
