class GitAbsorb < Formula
  desc "Automatic git commit --fixup"
  homepage "https://github.com/tummychow/git-absorb"
  url "https://github.com/tummychow/git-absorb/archive/0.4.0.tar.gz"
  sha256 "c494bde27ede695d6e2d86114c46acd015c76ddb49601a8a4f3119c0526601a1"

  bottle do
    cellar :any_skip_relocation
    sha256 "adcca55f215e92fe2707cb4061c35ae30cf9bc8631edf89319650440634de8e9" => :mojave
    sha256 "4029ab84e4bd7c57fd5b363725f25b181e4bc9d80b20b201096c6e087e31eea5" => :high_sierra
    sha256 "da2d4d04a66e4f3614143dddf15f59dfebf6dd689413bccccf72486cab8abad5" => :sierra
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
