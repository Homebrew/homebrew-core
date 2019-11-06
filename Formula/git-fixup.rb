class GitFixup < Formula
  desc "Alias for git commit --fixup <ref>"
  homepage "https://github.com/keis/git-fixup"
  url "https://github.com/keis/git-fixup/archive/v1.2.0.tar.gz"
  sha256 "894989bd31b52fcfbfe226bc86bd1baea06820aa86938561b14772929f261337"
  head "https://github.com/keis/git-fixup.git", :branch => "master"

  bottle do
    cellar :any_skip_relocation
    sha256 "72ff69fa75efeb1f6a5c5384d8084e65b67c1bd0cdf9668d402ab4271ce235f5" => :catalina
    sha256 "0fc85e047798c8602c8ad69796c6b6ac4d9759852bdba1b189aa0e999dfb53a2" => :mojave
    sha256 "0fc85e047798c8602c8ad69796c6b6ac4d9759852bdba1b189aa0e999dfb53a2" => :high_sierra
    sha256 "30b0473a2e18df5f4d91f61d74babf21fd5e8eccf9499d402f61790643400af7" => :sierra
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
    zsh_completion.install "completion.zsh" => "_git-fixup"
  end

  test do
    (testpath/".gitconfig").write <<~EOS
      [user]
        name = Real Person
        email = notacat@hotmail.cat
    EOS
    system "git", "init"
    (testpath/"test").write "foo"
    system "git", "add", "test"
    system "git", "commit", "--message", "Initial commit"

    (testpath/"test").delete
    (testpath/"test").write "bar"
    system "git", "add", "test"
    system "git", "fixup"
  end
end
