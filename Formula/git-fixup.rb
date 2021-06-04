class GitFixup < Formula
  desc "Alias for git commit --fixup <ref>"
  homepage "https://github.com/keis/git-fixup"
  url "https://github.com/keis/git-fixup/archive/v1.3.0.tar.gz"
  sha256 "29665151f82cac5f5807b8241392150e7c8ee8024ce37f23752c23c134516d57"
  license "ISC"
  head "https://github.com/keis/git-fixup.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9cba054279af11345ca5277b4984fbe627af6d576d872c0a412d3391a7ed25b7"
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
