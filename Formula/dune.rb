class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/3.8.1/dune-3.8.1.tbz"
  sha256 "9413a5d6eb9d7968a0463debb9d9f1be73025345809b827978d0c14db76cf914"
  license "MIT"
  head "https://github.com/ocaml/dune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c93fdb29b7665f8841815f60a89a91e6bdc8ff16f9a18eab1ca44f35a1f432a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96fdee8fd3f2281e666dc21bcbb995ac3aecb83645a7ca9e0cc12e6106c98c68"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "97270d88b147da250870ca03e7d5e1fa55dc5bba45e2695d983d767e2c42e9fb"
    sha256 cellar: :any_skip_relocation, ventura:        "2eece601720ef549449d72067781aa01c258d9eef28cc022a61acf3d03f60019"
    sha256 cellar: :any_skip_relocation, monterey:       "798030f8bb490bd9b2894c120c7494519191167edc6cc3020c33948b0ac8f27f"
    sha256 cellar: :any_skip_relocation, big_sur:        "c506384c6e5091cd5004a245afd6245bdd13eb6aaa62321d5a42c0442c89a12c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "529d3231eef67c829c0a32815406117db1c400dce7b529f8289c2c6d9899770f"
  end

  depends_on "ocaml" => [:build, :test]

  def install
    system "make", "release"
    system "make", "PREFIX=#{prefix}", "install"
    share.install prefix/"man"
    elisp.install Dir[share/"emacs/site-lisp/*"]
  end

  test do
    contents = "bar"
    target_fname = "foo.txt"
    (testpath/"dune").write("(rule (with-stdout-to #{target_fname} (echo #{contents})))")
    system bin/"dune", "build", "foo.txt", "--root", "."
    output = File.read(testpath/"_build/default/#{target_fname}")
    assert_match contents, output
  end
end
