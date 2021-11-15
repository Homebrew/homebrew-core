class GitArchiveAll < Formula
  include Language::Python::Shebang

  desc "Archive a project and its submodules"
  homepage "https://github.com/Kentzo/git-archive-all"
  url "https://github.com/Kentzo/git-archive-all/archive/1.23.0.tar.gz"
  sha256 "25f36948b704e57c47c98a33280df271de7fbfb74753b4984612eabb08fb2ab1"
  license "MIT"
  revision 2
  head "https://github.com/Kentzo/git-archive-all.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c943082d8a3627dfe6fbcb62f939158980af992a8e1f37a3f5958dfd6ce80293"
  end

  depends_on "python@3.10"

  def install
    rewrite_shebang detected_python_shebang, "*.py"

    system "make", "prefix=#{prefix}", "install"
  end

  test do
    (testpath/".gitconfig").write <<~EOS
      [user]
        name = Real Person
        email = notacat@hotmail.cat
    EOS
    system "git", "init"
    touch "homebrew"
    system "git", "add", "homebrew"
    system "git", "commit", "--message", "brewing"

    assert_equal "#{testpath.realpath}/homebrew => archive/homebrew",
                 shell_output("#{bin}/git-archive-all --dry-run ./archive").chomp
  end
end
