class GitAbsorb < Formula
  desc "Automatic git commit --fixup"
  homepage "https://github.com/tummychow/git-absorb"
  url "https://github.com/tummychow/git-absorb/archive/0.6.2.tar.gz"
  sha256 "0fc46c5e6bbb0b0be8b8c116f1713abe2c03d96e169c1d1e7efd470955a2238f"

  bottle do
    cellar :any_skip_relocation
    sha256 "8eaeea8615d48bc6d6cd16afb279411798ead7f7c18bf0bf335385bc4f544595" => :catalina
    sha256 "65f175f7acfb9b08f7eddad5dd422fae72f951c9995b1e36bc4c3f191d143c59" => :mojave
    sha256 "66c15f4eb683b12857385a9c458609366b49a54e9c21dfd533fb260d4f453127" => :high_sierra
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
