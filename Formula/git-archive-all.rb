class GitArchiveAll < Formula
  desc "Archive a project and its submodules"
  homepage "https://github.com/Kentzo/git-archive-all"
  url "https://github.com/Kentzo/git-archive-all/archive/1.15.tar.gz"
  sha256 "6ee01d0cc6e25c8536c748e1661b7890ab4c05324e0386a7d46c663c3658bfba"
  head "https://github.com/Kentzo/git-archive-all.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "408658894300a2f7ae5026a96e59b3ed80525de3af038824b13c06b61a24fdfa" => :sierra
    sha256 "408658894300a2f7ae5026a96e59b3ed80525de3af038824b13c06b61a24fdfa" => :el_capitan
    sha256 "408658894300a2f7ae5026a96e59b3ed80525de3af038824b13c06b61a24fdfa" => :yosemite
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
