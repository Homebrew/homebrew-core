class GitRevise < Formula
  include Language::Python::Virtualenv

  desc "Rebase alternative for easy & efficient in-memory rebases and fixups"
  homepage "https://github.com/mystor/git-revise"
  url "https://files.pythonhosted.org/packages/b7/51/771e8ecd76847a6e822d40e070604eb3d916bf25f73b369417a9789103d5/git_revise-0.8.0.tar.gz"
  sha256 "3239b1809cd659b33f6f323d3bfca5c7e3a9eb2eace223cf63b346f91c8c831c"
  license "MIT"
  head "https://github.com/mystor/git-revise.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3e1ae84726cd469773545306d82f51ede22cf7fe406b05f811fb59404012276c"
  end

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
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
