class GitAbsorb < Formula
  desc "Automatic git commit --fixup"
  homepage "https://github.com/tummychow/git-absorb"
  url "https://github.com/tummychow/git-absorb/archive/0.6.3.tar.gz"
  sha256 "d62ba36150d1113ea9216b8dc8f1f749c97a468cb41b2d1cd5c019158915ca70"
  license "BSD-3-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "bdf7c3b57f49dc9ccd83d9fed9f089f994f20c3591c6f18900f4e70ee80627e6" => :catalina
    sha256 "63d50725c92837dbd25b63560ee2b8061c8b335288230c9f3f5976b94aed6248" => :mojave
    sha256 "c6dc732ac254cc9d5aa2ebfe5ecc4e65c95b6ed860efc22b443c1911911099f4" => :high_sierra
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
