class GitArchiveAll < Formula
  desc "Archive a project and its submodules"
  homepage "https://github.com/Kentzo/git-archive-all"
  url "https://github.com/Kentzo/git-archive-all/archive/1.19.1.tar.gz"
  sha256 "bbbe9ca7b22feffa4f4db81a87df4f910a804504cfe12cb1330dd4b587fa44e6"
  head "https://github.com/Kentzo/git-archive-all.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7af14d3bbca008cc4ad58746d4cce4a8c1f027e06471607194eb465e374486bf" => :mojave
    sha256 "35c871caa01a78a32aba10062f5b859f77331d9e1cce58d87dac86f6699abda0" => :high_sierra
    sha256 "35c871caa01a78a32aba10062f5b859f77331d9e1cce58d87dac86f6699abda0" => :sierra
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
