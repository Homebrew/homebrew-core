class GitArchiveAll < Formula
  desc "Archive a project and its submodules"
  homepage "https://github.com/Kentzo/git-archive-all"
  url "https://github.com/Kentzo/git-archive-all/archive/1.21.0.tar.gz"
  sha256 "b86681429124908645ac4cf26916519f23cdf2599e7c8e37ae21d86be4ca02c4"
  head "https://github.com/Kentzo/git-archive-all.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "74c509f8ce278c1b12ef694749c5fedc9d056614f14ce4d6a01de1bb3803680f" => :catalina
    sha256 "74c509f8ce278c1b12ef694749c5fedc9d056614f14ce4d6a01de1bb3803680f" => :mojave
    sha256 "74c509f8ce278c1b12ef694749c5fedc9d056614f14ce4d6a01de1bb3803680f" => :high_sierra
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
