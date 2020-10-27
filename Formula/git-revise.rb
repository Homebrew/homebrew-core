class GitRevise < Formula
  include Language::Python::Virtualenv

  desc "Rebase alternative for easy & efficient in-memory rebases and fixups"
  homepage "https://github.com/mystor/git-revise"
  url "https://github.com/mystor/git-revise/archive/v0.6.0.tar.gz"
  sha256 "99c3804ddb73f1115bd6be05d10e640a7066e4019c6c223433e55136e66fa4c8"
  license "MIT"
  revision 1
  head "https://github.com/mystor/git-revise.git"

  bottle do
    cellar :any_skip_relocation
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
