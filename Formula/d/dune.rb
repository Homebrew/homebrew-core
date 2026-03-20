class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/3.22.0/dune-3.22.0.tbz"
  sha256 "cb816b2e672ca6c6ea680133f01287bd95a58ca611cb476acff67b8adbacf722"
  license "MIT"
  head "https://github.com/ocaml/dune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3cf224877c149cc3d1ba358eb6a21668d63377d1d11a40d55063f5a8281d8a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8d0cd766513aaf377fc72688c44bcf865c1809615e0a1131cf4e41953c1a289"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "658ce79ee865cb243f2586810aaba14c25886517b01de0d6028cfa3be857a0a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "29bd0017bcae4c0989b03daf7f843a3b40102edc10ed4036d3bdf2f32e8b8b7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc312aacc2df24acc1f57124018955beea99769fa5f4ce33be86f4cb038dd7df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f05bf173c0466bb4c3cc0c16e641172b02f5591a7d9765cff434dee20db84460"
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
