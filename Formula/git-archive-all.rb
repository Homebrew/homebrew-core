class GitArchiveAll < Formula
  desc "Archive a project and its submodules"
  homepage "https://github.com/Kentzo/git-archive-all"
  url "https://github.com/Kentzo/git-archive-all/archive/1.18.1.tar.gz"
  sha256 "60438ec520cf8365a8dde561afbe40257b9e2368fe68aae758f1804608de376e"
  head "https://github.com/Kentzo/git-archive-all.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a5cc850d9ae5379200b6fddda0f55f00fdfcf104ba5bdd76664c4471bd00fd7d" => :mojave
    sha256 "682cd60b854e006af8c0f58de0d83c96606d0f0045dc14555ca6565cad15ff31" => :high_sierra
    sha256 "682cd60b854e006af8c0f58de0d83c96606d0f0045dc14555ca6565cad15ff31" => :sierra
    sha256 "682cd60b854e006af8c0f58de0d83c96606d0f0045dc14555ca6565cad15ff31" => :el_capitan
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

    assert_equal "homebrew\n#{testpath.realpath}/homebrew => archive/homebrew",
                 shell_output("#{bin}/git-archive-all --dry-run ./archive").chomp
  end
end
