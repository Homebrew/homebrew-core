class GitArchiveAll < Formula
  desc "Archive a project and its submodules"
  homepage "https://github.com/Kentzo/git-archive-all"
  url "https://github.com/Kentzo/git-archive-all/archive/1.19.4.tar.gz"
  sha256 "00acfe0324862daaa01146d24b20337416318382d36be88c208a8f7576191d2b"
  head "https://github.com/Kentzo/git-archive-all.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ff59ba0f21957a49db840a0187b766022280f4e84dfba241c49dce2a4c0d80e9" => :mojave
    sha256 "2cdd2d75fc0014d99c7772540969ca546a134655e056164096fab54011ca9902" => :high_sierra
    sha256 "2cdd2d75fc0014d99c7772540969ca546a134655e056164096fab54011ca9902" => :sierra
  end

  def install
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
