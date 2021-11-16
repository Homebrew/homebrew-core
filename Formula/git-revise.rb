class GitRevise < Formula
  include Language::Python::Virtualenv

  desc "Rebase alternative for easy & efficient in-memory rebases and fixups"
  homepage "https://github.com/mystor/git-revise"
  url "https://files.pythonhosted.org/packages/8e/80/97eae3a7d93f8c17127ac5722ffb5a0f3b3bfd18525569865d2bfb5d27a1/git-revise-0.6.0.tar.gz"
  sha256 "21e89eba6602e8bea38b34ac6ec747acba2aee876f2e73ca0472476109e82bf4"
  license "MIT"
  revision 2
  head "https://github.com/mystor/git-revise.git", revision: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51ea42f3af7218aa18e655dc10892c646f394be2ac50a4a51879cd5e1aad059f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "51ea42f3af7218aa18e655dc10892c646f394be2ac50a4a51879cd5e1aad059f"
    sha256 cellar: :any_skip_relocation, monterey:       "8a6880070fdf65aef264f9e698be293832777a17c2b9aa395338b61da1cf9c39"
    sha256 cellar: :any_skip_relocation, big_sur:        "8a6880070fdf65aef264f9e698be293832777a17c2b9aa395338b61da1cf9c39"
    sha256 cellar: :any_skip_relocation, catalina:       "8a6880070fdf65aef264f9e698be293832777a17c2b9aa395338b61da1cf9c39"
    sha256 cellar: :any_skip_relocation, mojave:         "8a6880070fdf65aef264f9e698be293832777a17c2b9aa395338b61da1cf9c39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2e420f2730b973463b230a961270614c84a9a10edc2c12e0f4d62d179f35747"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
    man1.install "git-revise.1"
  end

  test do
    (testpath/".gitconfig").write <<~EOS
      [user]
        name = J. Random Tester
        email = test@example.com
    EOS
    system "git", "init"
    (testpath/"test").write "foo"
    system "git", "add", "test"
    system "git", "commit", "--message", "a bad message"
    system "git", "revise", "--message", "a good message", "HEAD"
    assert_match "a good message", shell_output("git log --format=%B -n 1 HEAD")
  end
end
