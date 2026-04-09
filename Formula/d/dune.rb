class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/3.22.1/dune-3.22.1.tbz"
  sha256 "0c0b98396c32ec426886c2c2294024fd687ac5114d4dda0af9dc8a2e584d47fd"
  license "MIT"
  head "https://github.com/ocaml/dune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3f3b3ee8fbc1b65ae9730e50851ac1e702b78455ac0035b565a2ed1e19b32df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6130b1400ab35f0124fd4dfd796a0ccf0ddfb098f19049f96dc896706e2e50fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c43fcc62195ddc615af9bdff8872ec4146b6fadcf9285ccc6bed127f7be0e33"
    sha256 cellar: :any_skip_relocation, sonoma:        "df6f291fdf49d97b629fe1fb14cc070a3f0bfd8c0ecda390a5fec2f0ed0d8c3f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f3bc8e848d6a5efa6c06d1e25e4544f84e31e741e239ab694e547d2ac4756b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef0587053e3a06e633c9b636de313ec69636a15dc554c6b318677193d1dab8b9"
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
