class GitArchiveAll < Formula
  desc "Archive a project and its submodules"
  homepage "https://github.com/Kentzo/git-archive-all"
  url "https://github.com/Kentzo/git-archive-all/archive/1.18.2.tar.gz"
  sha256 "a0a969eb12ddf9ebcb39e458a5971c47d15c01483c9f60775deb68426ad1597e"
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
