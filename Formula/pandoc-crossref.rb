require "language/haskell"

class PandocCrossref < Formula
  include Language::Haskell::Cabal

  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://hackage.haskell.org/package/pandoc-crossref-0.3.7.0/pandoc-crossref-0.3.7.0.tar.gz"
  sha256 "467d2470fa66885179284e54d8757ae1a9b442b6ff8af33bd177870f285b85d7"

  bottle do
    cellar :any_skip_relocation
    sha256 "f04b851f02319fd92da28167c0298cf72b1c1e06b23e3f94e039987da5a2a206" => :catalina
    sha256 "0e6a92c4cce6fb1f1db797aeee44bacad441c75d5cc8fe8994bc0d0504a94d4c" => :mojave
    sha256 "842afa5b52e2da4d8ac32be472fa1a0dfc9643ca5dc778a7241c57bfa9831b3c" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pandoc"

  def install
    install_cabal_package
  end

  test do
    (testpath/"hello.md").write <<~EOS
      Demo for pandoc-crossref.
      See equation @eq:eqn1 for cross-referencing.
      Display equations are labelled and numbered

      $$ P_i(x) = \\sum_i a_i x^i $$ {#eq:eqn1}
    EOS
    system Formula["pandoc"].bin/"pandoc", "-F", bin/"pandoc-crossref", "-o", "out.html", "hello.md"
    assert_match "∑", (testpath/"out.html").read
  end
end
