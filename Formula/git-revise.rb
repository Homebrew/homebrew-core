class GitRevise < Formula
  include Language::Python::Virtualenv

  desc "Rebase alternative for easy & efficient in-memory rebases and fixups"
  homepage "https://github.com/mystor/git-revise"
  url "https://github.com/mystor/git-revise/archive/0.5.1.tar.gz"
  sha256 "3f64521eb056ff097eb282811459820e1afd138cf2de113d609051060459d24d"
  revision 1
  head "https://github.com/mystor/git-revise.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d25746db926cb4a9e136b74acf2fd8df47610b25a0f437eed3b82259982749d6" => :catalina
    sha256 "cb63eb946034bd4f4351b9726ee8649282a1ebe1a7a28910a470344719a96fdf" => :mojave
    sha256 "5659d2d32986473c77135b28f52da15cd2a09a4dfdb8d959b640be765c9a5460" => :high_sierra
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
