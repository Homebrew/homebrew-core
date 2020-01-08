class GitAbsorb < Formula
  desc "Automatic git commit --fixup"
  homepage "https://github.com/tummychow/git-absorb"
  url "https://github.com/tummychow/git-absorb/archive/0.5.0.tar.gz"
  sha256 "c4ef4fa28222773d695aab7711abbfac7e81c35a37eafe45f79d045516df28b1"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a4c692c6a939cb32c74a9a0d307a6c7b724ba6119893261b0b8d0805d1ac18c8" => :catalina
    sha256 "d09dccdcb396edabf3238f73b92f5f9f389c91cfd7cd1a45702984db67229b69" => :mojave
    sha256 "ba2a3614b72b498ed571d8cccbe9ecdfd6874a960eb0d4b466d3086fa4c10142" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
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
