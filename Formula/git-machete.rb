class GitMachete < Formula
  include Language::Python::Virtualenv

  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https://github.com/VirtusLab/git-machete"
  url "https://pypi.org/packages/source/g/git-machete/git-machete-3.13.0.tar.gz"
  sha256 "1dc441ee9ce1332a3cf9869bbe0fdcffd255c9e0cb2afa07e08cb67c9dc81e69"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a4547f07b1705c6f9997ee9c3d7fb07d200082ff27a4a788b367306626039ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a4547f07b1705c6f9997ee9c3d7fb07d200082ff27a4a788b367306626039ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a4547f07b1705c6f9997ee9c3d7fb07d200082ff27a4a788b367306626039ad"
    sha256 cellar: :any_skip_relocation, ventura:        "85aa51fadf81da0e60dd352ba2e6276a7e81a08c9e303e34436247be8690d0d8"
    sha256 cellar: :any_skip_relocation, monterey:       "85aa51fadf81da0e60dd352ba2e6276a7e81a08c9e303e34436247be8690d0d8"
    sha256 cellar: :any_skip_relocation, big_sur:        "85aa51fadf81da0e60dd352ba2e6276a7e81a08c9e303e34436247be8690d0d8"
    sha256 cellar: :any_skip_relocation, catalina:       "85aa51fadf81da0e60dd352ba2e6276a7e81a08c9e303e34436247be8690d0d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4cff80f8eb6d06304e0a060bb519dd3baf3c1ec2ba770a094e90ecdccde1d08"
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
