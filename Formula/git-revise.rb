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
    sha256 "2fe7e2bef591f6217c5f3a9a6b3e1f2ff6b3f466c45bf1fdff93eb374a45c4d0" => :catalina
    sha256 "7bcefb4419a81a205bae28b633718a5bcd3fd0b8c21543159d19e3e2a2684db8" => :mojave
    sha256 "e59554a284ee4aed9ce5d65b65c998f359af9de928064c6b857befe9551335ba" => :high_sierra
  end

  depends_on "python@3.8"

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
