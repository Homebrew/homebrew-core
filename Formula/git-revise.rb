class GitRevise < Formula
  include Language::Python::Virtualenv

  desc "Rebase alternative for easy & efficient in-memory rebases and fixups"
  homepage "https://github.com/mystor/git-revise"
  url "https://github.com/mystor/git-revise/archive/0.5.1.tar.gz"
  sha256 "3f64521eb056ff097eb282811459820e1afd138cf2de113d609051060459d24d"
  revision 2
  head "https://github.com/mystor/git-revise.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "72ca393035b15d0cf921632069389001266a1106f1ff943c34dc923af866c77b" => :catalina
    sha256 "2800e4ffabf68b829e4d8fe2b32e605e88c9a93eb52c42966f7cb162b49e95cc" => :mojave
    sha256 "6444ff85b3cc61e10bc9c48fee39319684837d5d7de762d94c4c41a6152fde3a" => :high_sierra
  end

  depends_on "python@3.8"

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
