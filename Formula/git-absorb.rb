class GitAbsorb < Formula
  desc "Automatic git commit --fixup"
  homepage "https://github.com/tummychow/git-absorb"
  url "https://github.com/tummychow/git-absorb/archive/0.3.0.tar.gz"
  sha256 "94d540a7febd37cd74e95e7cab71ee3514df020989208ce3fe83560699072730"

  bottle do
    cellar :any_skip_relocation
    sha256 "eb30a21fcd537f59c44e16da4a39df10830fed394d58b3b4e51a2da4cf65cc62" => :mojave
    sha256 "47b15af4840774370a83de7b5df11b3295b1da0586dbe8959c05925fa220c0a9" => :high_sierra
    sha256 "701549ab63e18acc2524e5d857813fff8f3dadb34a45ead1ccc127b840fe9281" => :sierra
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
