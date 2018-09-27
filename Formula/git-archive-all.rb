class GitArchiveAll < Formula
  desc "Archive a project and its submodules"
  homepage "https://github.com/Kentzo/git-archive-all"
  url "https://github.com/Kentzo/git-archive-all/archive/1.18.3.tar.gz"
  sha256 "2f01b94dbcf3e100370e97a4dee8b25fa60a41df207a192a8c58af37ab2a0f3b"
  head "https://github.com/Kentzo/git-archive-all.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5b25a67a61e409324ca34e329bc22a794a5ad909594cae59474d03ee25267f78" => :mojave
    sha256 "b20ce0b2f45e23040f4a73a2da9801609e918ece696825d422fb51ed2f2a771a" => :high_sierra
    sha256 "b20ce0b2f45e23040f4a73a2da9801609e918ece696825d422fb51ed2f2a771a" => :sierra
    sha256 "b20ce0b2f45e23040f4a73a2da9801609e918ece696825d422fb51ed2f2a771a" => :el_capitan
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
