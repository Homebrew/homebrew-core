class GitAbsorb < Formula
  desc "Automatic git commit --fixup"
  homepage "https://github.com/tummychow/git-absorb"
  url "https://github.com/tummychow/git-absorb/archive/0.6.0.tar.gz"
  sha256 "945534d1f6bf99314085c16d2c13ec9d0fe75c8b3e88b83723858004c5e6e928"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "3bb0cdb801822bcca8d207e17acb25af6c03ee4607b2a932d55e073bc474892d" => :catalina
    sha256 "ea8426b2fda51ac974472ce14255167083e4a62ef68d813a5f4197718dd0682a" => :mojave
    sha256 "ccb40f846bf42ce788ebd469b4f7bb62d604f00e6678ed9cb76d3900dfbc89eb" => :high_sierra
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
    man1.install "Documentation/git-absorb.1"
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
    system "git", "absorb"
  end
end
