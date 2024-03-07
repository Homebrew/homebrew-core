class GitRevise < Formula
  include Language::Python::Virtualenv

  desc "Rebase alternative for easy & efficient in-memory rebases and fixups"
  homepage "https://github.com/mystor/git-revise"
  url "https://files.pythonhosted.org/packages/99/fe/03e0afc973c19af8ebf9c7a4a090a974c0c39578b1d4082d201d126b7f9a/git-revise-0.7.0.tar.gz"
  sha256 "af92ca2e7224c5e7ac2e16ed2f302dd36839a33521655c20fe0b7d693a1dc4c4"
  license "MIT"
  head "https://github.com/mystor/git-revise.git", branch: "main"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5a47af84d787b9dd31fbc70a63201f8b1aeb4229fcbf88ccc9c4490df88f0c44"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9ee2921cac14ddea79e4c1e020e1b8d544e5bba16f5fcc2796b21ac6566a9f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a85791ce1eaa49f13c5ad465d361dccb9b7afba1177e9b542f083f90321a1005"
    sha256 cellar: :any_skip_relocation, sonoma:         "8aa99a449a1352eca08754aa2ee6f85e5f96c65a9d7caf22d84b35755ef2a589"
    sha256 cellar: :any_skip_relocation, ventura:        "75db0a7e791194ff3f89f0fce29a4998a92a9b3a532864bc6532544c9fe3e4e7"
    sha256 cellar: :any_skip_relocation, monterey:       "6896a89a70307bf7487bf96ef4a65003e17e37e6636b4c05b19c4798b10fd3ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e5a2a0b8b28bc4151e1c06d88d8bcc401334c7cfd27c1122b7e9cbdcbdfd113"
  end

  depends_on "python@3.12"

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
