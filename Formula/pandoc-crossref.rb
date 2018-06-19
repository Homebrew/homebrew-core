require "language/haskell"

class PandocCrossref < Formula
  include Language::Haskell::Cabal

  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://hackage.haskell.org/package/pandoc-crossref-0.3.2.1/pandoc-crossref-0.3.2.1.tar.gz"
  sha256 "86023c1df83d1375eb8620ac4dcd91a3be581349bd91d802a63fc4ec1eb6b167"

  bottle do
    cellar :any_skip_relocation
    sha256 "ef6cdca1d0ad0a336800ea8cd54ba234e1ce88388f2dce4ea785cec0aebdf163" => :high_sierra
    sha256 "69328d60dc31932b8dbbbd44eb367227a5b6c99dfa225121d1b9895c9354632a" => :sierra
    sha256 "335d74d22d886b6bbf057fa057f3f2741aa5f72231233564979c9f75d842e242" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pandoc"

  def install
    args = []
    args << "--constraint=cryptonite -support_aesni" if MacOS.version <= :lion
    install_cabal_package *args
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
