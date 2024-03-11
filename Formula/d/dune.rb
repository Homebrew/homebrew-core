class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/3.14.1/dune-3.14.1.tbz"
  sha256 "ea83f9ab24455248ec65288d0f3c4272a5716b61c78f13a87de3d0ac45aed136"
  license "MIT"
  head "https://github.com/ocaml/dune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1a7e786071a172bc49cbd1fc96e5dc8ac15746e8ce1a1ef72356bc1424b7c1e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1d292bf403b2a6c168a8909138de76629e6bf22f2fc3d5ab7c53442a9c39e49"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "688076ec14520bc460dfbdaa81c93e736dacd90d0dbf01acea4020b6d7dd27ee"
    sha256 cellar: :any_skip_relocation, sonoma:         "bf1025da9e819d8dca825c2697b9c19c9813b38ac6551f5e344b9d4599a1fbd9"
    sha256 cellar: :any_skip_relocation, ventura:        "48b51aee8ef0d9dda98e892d1354ee09dc84d429923369c7e65f21fc51f0056f"
    sha256 cellar: :any_skip_relocation, monterey:       "b0106112e48abdbff9ae0d06ccf9bb321ef9c330202323f4b0e473850dea279e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39fb6353a264a7176d05aea2b861febfcd8d1433a439ff51817cf34f89cdd875"
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
