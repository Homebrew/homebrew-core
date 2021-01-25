class GitAbsorb < Formula
  desc "Automatic git commit --fixup"
  homepage "https://github.com/tummychow/git-absorb"
  url "https://github.com/tummychow/git-absorb/archive/0.6.6.tar.gz"
  sha256 "955069cc70a34816e6f4b6a6bd1892cfc0ae3d83d053232293366eb65599af2f"
  license "BSD-3-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "1a960e64840655e62b5bfdbdf5b235650b6d6655c32eaac05f9afb1b472893ef" => :big_sur
    sha256 "c990b0116058e091c06b246e985bdd81e84a88f7078254c1253f0b2ea41ccd28" => :arm64_big_sur
    sha256 "663a57962ac9400e4b35164b82358025b1304c5097ff8841043a8885ba8881ea" => :catalina
    sha256 "afa2140c2f7e4f26c4027c3871a1f6b9f1522b9ef64b59cec358383247ae8263" => :mojave
    sha256 "42f677cb8adf051c212bc04ada5a0527289a0491d58d1b0ea71dbe4a04115c39" => :high_sierra
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
