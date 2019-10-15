class GitAbsorb < Formula
  desc "Automatic git commit --fixup"
  homepage "https://github.com/tummychow/git-absorb"
  url "https://github.com/tummychow/git-absorb/archive/0.5.0.tar.gz"
  sha256 "c4ef4fa28222773d695aab7711abbfac7e81c35a37eafe45f79d045516df28b1"

  bottle do
    cellar :any_skip_relocation
    sha256 "0eb9c509d984ad2345f3d5b3bd8e6fb28fb4590bc937350dbc39990452c9e638" => :catalina
    sha256 "4a8e3e6fa101306c8d99bf95634a7fbe08fcb80d46742161b972e9f5ab1031b5" => :mojave
    sha256 "6723320cdbcef35818dc58ce6e0fcd3be87606ae59fc355d9179e5690bc90540" => :high_sierra
    sha256 "d51c5da6ae0c17b416d0fb2bf1f043c7d0e3cb8535a47dc0afea56ef96a50f1f" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
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
