class GitAbsorb < Formula
  desc "Automatic git commit --fixup"
  homepage "https://github.com/tummychow/git-absorb"
  url "https://github.com/tummychow/git-absorb/archive/0.4.0.tar.gz"
  sha256 "c494bde27ede695d6e2d86114c46acd015c76ddb49601a8a4f3119c0526601a1"

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
