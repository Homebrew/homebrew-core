class GitArchiveAll < Formula
  desc "Archive a project and its submodules"
  homepage "https://github.com/Kentzo/git-archive-all"
  url "https://github.com/Kentzo/git-archive-all/archive/1.16.4.tar.gz"
  sha256 "90ea149344cc467f218b4845521e6a86f6345d1bda92505d7dd384c3d9242cb1"
  head "https://github.com/Kentzo/git-archive-all.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "76c8a8c7a9b4918e8cd9751dd99bf2648711a1d7450949dc434415ea26d020cc" => :sierra
    sha256 "76c8a8c7a9b4918e8cd9751dd99bf2648711a1d7450949dc434415ea26d020cc" => :el_capitan
    sha256 "76c8a8c7a9b4918e8cd9751dd99bf2648711a1d7450949dc434415ea26d020cc" => :yosemite
  end

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    (testpath/".gitconfig").write <<-EOS.undent
      [user]
        name = Real Person
        email = notacat@hotmail.cat
      EOS
    system "git", "init"
    touch "homebrew"
    system "git", "add", "homebrew"
    system "git", "commit", "--message", "brewing"

    assert_equal "#{testpath.realpath}/homebrew => archive/homebrew",
                 shell_output("#{bin}/git-archive-all --dry-run ./archive", 0).chomp
  end
end
