require "language/haskell"

class PandocCrossref < Formula
  include Language::Haskell::Cabal

  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://hackage.haskell.org/package/pandoc-crossref-0.3.0.1/pandoc-crossref-0.3.0.1.tar.gz"
  sha256 "d62bc57ecbf869cd5777dfc69f3d45722d3be3e691ed4e47841aa656df5c1252"

  bottle do
    cellar :any_skip_relocation
    sha256 "c2c0dbee94fc1e080e36fad1281672f91f0ff25b5c2269806479c5d2a93d13b6" => :high_sierra
    sha256 "5a3b1158fe0621d5f5e03ee731c36239b85be63f9aae09af1c8cde204a72d33d" => :sierra
    sha256 "a61456335f640fb85c260c02b651acca78775c12be196a379a696fb5732db41b" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pandoc" => :run

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
