class GitRevise < Formula
  include Language::Python::Virtualenv

  desc "Rebase alternative for easy & efficient in-memory rebases and fixups"
  homepage "https://github.com/mystor/git-revise"
  url "https://files.pythonhosted.org/packages/99/fe/03e0afc973c19af8ebf9c7a4a090a974c0c39578b1d4082d201d126b7f9a/git-revise-0.7.0.tar.gz"
  sha256 "af92ca2e7224c5e7ac2e16ed2f302dd36839a33521655c20fe0b7d693a1dc4c4"
  license "MIT"
  head "https://github.com/mystor/git-revise.git", revision: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "187dca8b0f934d9b42adcb5b515fd7949b31893c32be6696d91252fb34601c4f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "187dca8b0f934d9b42adcb5b515fd7949b31893c32be6696d91252fb34601c4f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "187dca8b0f934d9b42adcb5b515fd7949b31893c32be6696d91252fb34601c4f"
    sha256 cellar: :any_skip_relocation, ventura:        "f6eea6ab552651d2c45035be1db8c1203e0239b4c763612c3e3996f1b94c150f"
    sha256 cellar: :any_skip_relocation, monterey:       "f6eea6ab552651d2c45035be1db8c1203e0239b4c763612c3e3996f1b94c150f"
    sha256 cellar: :any_skip_relocation, big_sur:        "f6eea6ab552651d2c45035be1db8c1203e0239b4c763612c3e3996f1b94c150f"
    sha256 cellar: :any_skip_relocation, catalina:       "f6eea6ab552651d2c45035be1db8c1203e0239b4c763612c3e3996f1b94c150f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fd6f6b10d6617c98b3ecf7752848224130a1ad14cc776888d17d65bf0360554"
  end

  depends_on "python@3.11"

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
