class GitRevise < Formula
  include Language::Python::Virtualenv

  desc "Rebase alternative for easy & efficient in-memory rebases and fixups"
  homepage "https://github.com/mystor/git-revise"
  url "https://files.pythonhosted.org/packages/99/fe/03e0afc973c19af8ebf9c7a4a090a974c0c39578b1d4082d201d126b7f9a/git-revise-0.7.0.tar.gz"
  sha256 "af92ca2e7224c5e7ac2e16ed2f302dd36839a33521655c20fe0b7d693a1dc4c4"
  license "MIT"
  head "https://github.com/mystor/git-revise.git", revision: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f24bc3d536e9aa3ee38043d2d7f42169234474b6bff0d6f6dbdbf497c776f5e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "938a6cfb9895ec730d162419eed3a0f0df43d0810c9599809ca25484d7355adf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d460d4fc56c643947602a3e171891d9b4d79679c49d982860fbb5039a725b5f5"
    sha256 cellar: :any_skip_relocation, sonoma:         "9d526b3ee9ec7ac180a06861fe45f0dfd56d87c2d2f2a31603e99e04450b6e63"
    sha256 cellar: :any_skip_relocation, ventura:        "8df48a5acf737f4910de8a4a9e0d2b8e451811897801fd5c64635dbf02462e4b"
    sha256 cellar: :any_skip_relocation, monterey:       "b332573f0ea2df96b297f348d1097407fc03d0dd1233b98b1e6d80f735638453"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e820a84ec1cfd1c0f6fd708b00ad52f8029c88c0f0147fa23f88542ae7756029"
  end

  depends_on "python@3.12"

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
