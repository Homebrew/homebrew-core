class GitAbsorb < Formula
  desc "Automatic git commit --fixup"
  homepage "https://github.com/tummychow/git-absorb"
  url "https://github.com/tummychow/git-absorb/archive/0.6.5.tar.gz"
  sha256 "0c8bf3520209f6d292515ccaaa4b91d7d5e18bd8abe41fad049b5a2797386892"
  license "BSD-3-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "e4f8afc0556751bf7bce12294fa6b0d13d2b6b35a592f74ffd9ae42d692ffc32" => :catalina
    sha256 "dd12357127c05d4f3b0b8fcde610ecbd2bd2f99f38a2acbbeb75957edcbacf9d" => :mojave
    sha256 "2b4e43d04f83bb331a0521ed67938066068a7eb0ee06588ef482eab4fb306be9" => :high_sierra
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
