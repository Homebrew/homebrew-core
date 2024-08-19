class GitRevise < Formula
  include Language::Python::Virtualenv

  desc "Rebase alternative for easy & efficient in-memory rebases and fixups"
  homepage "https://github.com/mystor/git-revise"
  url "https://files.pythonhosted.org/packages/99/fe/03e0afc973c19af8ebf9c7a4a090a974c0c39578b1d4082d201d126b7f9a/git-revise-0.7.0.tar.gz"
  sha256 "af92ca2e7224c5e7ac2e16ed2f302dd36839a33521655c20fe0b7d693a1dc4c4"
  license "MIT"
  head "https://github.com/mystor/git-revise.git", branch: "main"

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "11dee0e25565318d45ab229acba72ad2c6d361e189cd2705640108f785bd9ea6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "588a6d0106afa9238ff313c2912587509d6edc4742dcee636cbd5c734abd4a17"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5edfb6441cfd0d7398e3258a8f84a837ef11425e6b161be2bf58d1da255a7e29"
    sha256 cellar: :any_skip_relocation, sonoma:         "ffb5825703b89a7e69d3448f7052bfea2f88204cfe995ff9e4fb4938728dfdeb"
    sha256 cellar: :any_skip_relocation, ventura:        "5aa4462e2e945c8c6d52318617a3a098261b4e22adaefb637b400e25c4865eee"
    sha256 cellar: :any_skip_relocation, monterey:       "3aa713d6b837d9d0201e9efe402f2e367c06fbe8a3033a8e861c749d3ba1f748"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8cc6240886847417ae649ca83c00b2872942e3ccf7f545bdde1cf9d22dc52471"
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
