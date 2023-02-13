class GitMachete < Formula
  include Language::Python::Virtualenv

  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https://github.com/VirtusLab/git-machete"
  url "https://pypi.org/packages/source/g/git-machete/git-machete-3.15.1.tar.gz"
  sha256 "a3c3889b5dfdf644352cc6b0a4f412742d80f4a669e9625b5d629b4efff2afe4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a49d08eb3c6f725b01f0e925f17e21de05f14cc143edd337f38e19dfb9665ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51a5e0a7d3a52d1cb790215aadbfa9306d136d55c935dcf2a2232031de6b7eb0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3fa42cb142e03e3f7fb41ec5ef9de6ab83faa56cdb05a17ae8808c6dff9fa4d5"
    sha256 cellar: :any_skip_relocation, ventura:        "172707ad261eeca02632eb4258332cd22d20ea187a5e8feb5b125e6b0d0a284b"
    sha256 cellar: :any_skip_relocation, monterey:       "ad077480aeb2ae1fa5a9c2ffd065595b3248d83fd5081b90f3355e0b9da58451"
    sha256 cellar: :any_skip_relocation, big_sur:        "86aa41b5a5665c53178b6821ccdf7e6bfd6eecdcd2669da645974d6b1fa203ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e21fc7b8db3f9464b774b3b80eef1273e5d2a29583f907205b5abb37c92beb0"
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
