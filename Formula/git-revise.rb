class GitRevise < Formula
  include Language::Python::Virtualenv

  desc "Rebase alternative for easy & efficient in-memory rebases and fixups"
  homepage "https://github.com/mystor/git-revise"
  url "https://github.com/mystor/git-revise/archive/0.5.0.tar.gz"
  sha256 "f2bd6ad51b2acdd6fb6acf51807ce4b951d92cd039fc9e5a7dbb1e182fdf38b4"
  head "https://github.com/mystor/git-revise.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "97160063eb1ec4736cff67cbcb58985fc449f170c7c436d38fc62890a91477d5" => :mojave
    sha256 "3deb5e0b5b76ad96eda2ecf22e3a629a5e60501e071bfc5e8c79040a4e818797" => :high_sierra
    sha256 "e5fa8f56b824a9c23fb4e7cdadb69c62d4c447f28da635ca175ca7628cb12f5b" => :sierra
  end

  depends_on "python"

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
