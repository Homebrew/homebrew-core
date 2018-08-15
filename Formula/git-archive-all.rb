class GitArchiveAll < Formula
  desc "Archive a project and its submodules"
  homepage "https://github.com/Kentzo/git-archive-all"
  url "https://github.com/Kentzo/git-archive-all/archive/1.18.0.tar.gz"
  sha256 "8360c4674891b9f3b2a08e557761ac0c2972b6c32c50b63f81748f1437c43655"
  head "https://github.com/Kentzo/git-archive-all.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9690a44ef2c8a48e2a53eb3c825dcc1082f58d4acc7e9bf99602e166d8b46c9d" => :high_sierra
    sha256 "9690a44ef2c8a48e2a53eb3c825dcc1082f58d4acc7e9bf99602e166d8b46c9d" => :sierra
    sha256 "9690a44ef2c8a48e2a53eb3c825dcc1082f58d4acc7e9bf99602e166d8b46c9d" => :el_capitan
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
