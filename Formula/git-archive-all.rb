class GitArchiveAll < Formula
  desc "Archive a project and its submodules"
  homepage "https://github.com/Kentzo/git-archive-all"
  url "https://github.com/Kentzo/git-archive-all/archive/1.17.1.tar.gz"
  sha256 "c5fb6de7fd105dbe25cce7500e5d3032a5530467848c5b6464224e327a954de6"
  head "https://github.com/Kentzo/git-archive-all.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d4bfe6683cec5c08fbd701d4b431256cf42315746260e53a4655127e89df9048" => :high_sierra
    sha256 "d4bfe6683cec5c08fbd701d4b431256cf42315746260e53a4655127e89df9048" => :sierra
    sha256 "d4bfe6683cec5c08fbd701d4b431256cf42315746260e53a4655127e89df9048" => :el_capitan
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
                 shell_output("#{bin}/git-archive-all --dry-run ./archive", 0).chomp
  end
end
