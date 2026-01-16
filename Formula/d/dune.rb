class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/3.21.0/dune-3.21.0.tbz"
  sha256 "e76d4d89368a0a70025193aeaf4f7c5b54031dba3f59bf9d2af1971dc0eceddd"
  license "MIT"
  head "https://github.com/ocaml/dune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e79ea1790d9042f99cba04bdbdad82925c14cf2cfa1ac2ce0302b6f0bc409594"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90447aafe35ad8a0a7ae49e9d49cae497fde683c8cb88567051cb22089d9a75c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dcbb124433c20da85c3fdac9eca05a5304115259114df69f762e7fd2ddc9d2a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ac7ff08002694a250b40aa521dc42f9cedeff7db41d21ba69daf4fa0df797f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b59603a0ee129aa95977eebf9525b82d59b662e5335f6eba3a5dcdc5d398b482"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2ca3d4d11af98fdc84810bf30c8d09c288c09113649b997a5eeb62f298b898f"
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
