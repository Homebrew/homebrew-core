class GitRevise < Formula
  include Language::Python::Virtualenv

  desc "Rebase alternative for easy & efficient in-memory rebases and fixups"
  homepage "https://github.com/mystor/git-revise"
  url "https://files.pythonhosted.org/packages/99/fe/03e0afc973c19af8ebf9c7a4a090a974c0c39578b1d4082d201d126b7f9a/git-revise-0.7.0.tar.gz"
  sha256 "af92ca2e7224c5e7ac2e16ed2f302dd36839a33521655c20fe0b7d693a1dc4c4"
  license "MIT"
  head "https://github.com/mystor/git-revise.git", revision: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6eee8e1415f615aeef5726cb7c82834357f3d2868f21e30ed128d6c51a889e8b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6eee8e1415f615aeef5726cb7c82834357f3d2868f21e30ed128d6c51a889e8b"
    sha256 cellar: :any_skip_relocation, monterey:       "aac1ccf21a7f370ad64d30bc92cefab901913bc81b7561ce3b4232036d28da0c"
    sha256 cellar: :any_skip_relocation, big_sur:        "aac1ccf21a7f370ad64d30bc92cefab901913bc81b7561ce3b4232036d28da0c"
    sha256 cellar: :any_skip_relocation, catalina:       "aac1ccf21a7f370ad64d30bc92cefab901913bc81b7561ce3b4232036d28da0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e55a7ac0fd6a079cb4f5f79c01bc5448f1b415906d6df7f5d3a9851dfa208e58"
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
