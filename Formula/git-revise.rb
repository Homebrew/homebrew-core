class GitRevise < Formula
  include Language::Python::Virtualenv

  desc "Rebase alternative for easy & efficient in-memory rebases and fixups"
  homepage "https://github.com/mystor/git-revise"
  url "https://files.pythonhosted.org/packages/8e/80/97eae3a7d93f8c17127ac5722ffb5a0f3b3bfd18525569865d2bfb5d27a1/git-revise-0.6.0.tar.gz"
  sha256 "21e89eba6602e8bea38b34ac6ec747acba2aee876f2e73ca0472476109e82bf4"
  license "MIT"
  revision 1
  head "https://github.com/mystor/git-revise.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "4b02d17b10a298ddf872c2d43fe836064d51b382abc1db9557fe1f8e1607a1fb" => :big_sur
    sha256 "0945e65a5518863a750ce850f47b943008b0b270943c444f00c1001aeaf16266" => :arm64_big_sur
    sha256 "1d04c34ac1606c6918141e94194f2d9c22c7a39179a8652b928dddb8c4064374" => :catalina
    sha256 "8c812be3c150c174ce7774b35dc35f9c8322ffbac8d32748c26dbb4340f08fb0" => :mojave
    sha256 "b6f7e178e2862dd4ed3d14c0282da9eaec7bc124d1409d35858f1206c0de5bbd" => :high_sierra
  end

  depends_on "python@3.9"

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
