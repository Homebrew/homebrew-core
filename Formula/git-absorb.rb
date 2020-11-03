class GitAbsorb < Formula
  desc "Automatic git commit --fixup"
  homepage "https://github.com/tummychow/git-absorb"
  url "https://github.com/tummychow/git-absorb/archive/0.6.6.tar.gz"
  sha256 "955069cc70a34816e6f4b6a6bd1892cfc0ae3d83d053232293366eb65599af2f"
  license "BSD-3-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "32fc0d304fa59c9193d7cf28ff21b0d606b0e1d22a8b3fe2b10a2efe2267e03e" => :catalina
    sha256 "559229de495315dfc22fbffa16540a12e2c80ed0fc422e0e379b23adf52e1f18" => :mojave
    sha256 "19d4cc345118a1ca56d2bdfdf2de2b4200004172af49969a0b2c4d9290ed87ca" => :high_sierra
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
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
