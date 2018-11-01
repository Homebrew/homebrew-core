class GitArchiveAll < Formula
  desc "Archive a project and its submodules"
  homepage "https://github.com/Kentzo/git-archive-all"
  url "https://github.com/Kentzo/git-archive-all/archive/1.19.1.tar.gz"
  sha256 "bbbe9ca7b22feffa4f4db81a87df4f910a804504cfe12cb1330dd4b587fa44e6"
  head "https://github.com/Kentzo/git-archive-all.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5a8bc52384feed58d8e92818f2b05f384ace521aa14dd072b16d1e9e85b08386" => :mojave
    sha256 "c19f735bcec4c357834d24bc7d3798b99668ffcfd4b1c7c9f2bd1103e1cdc533" => :high_sierra
    sha256 "c19f735bcec4c357834d24bc7d3798b99668ffcfd4b1c7c9f2bd1103e1cdc533" => :sierra
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
