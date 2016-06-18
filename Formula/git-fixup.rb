class GitFixup < Formula
  desc "Alias for git commit --fixup <ref>"
  homepage "https://github.com/keis/git-fixup"
  url "https://github.com/keis/git-fixup/archive/v1.1.0.tar.gz"
  sha256 "6e166709a18a0417776592493b82dc87f38766295825cfa68ce41adbf608c78e"

  head "https://github.com/keis/git-fixup.git", :branch => "master"

  bottle do
    cellar :any_skip_relocation
    sha256 "2abea2c18d5dca1574cb31306064ebc5051ffe305ec509ff9e0c1653ea8b739e" => :el_capitan
    sha256 "fde4a33d694d5d4de7c0d57d7c5ff5743c096ac5f8ce2c615af50ad53fd56c0b" => :yosemite
    sha256 "3691cee4d3208c1bf6e0af364ddde4a3e4ba552fc5364d37cef1cca74d81e664" => :mavericks
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
    zsh_completion.install "completion.zsh" => "_git-fixup"
  end

  test do
    (testpath/".gitconfig").write <<-EOS.undent
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
