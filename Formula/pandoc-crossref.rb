require "language/haskell"

class PandocCrossref < Formula
  include Language::Haskell::Cabal

  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://hackage.haskell.org/package/pandoc-crossref-0.3.4.0/pandoc-crossref-0.3.4.0.tar.gz"
  sha256 "ff5515e76884aa0d7f9991fc22853622b185a92f940084d2d396133eddc56e97"

  bottle do
    cellar :any_skip_relocation
    sha256 "b921f684a1f3418cbc0b315c249c087f0dd76dba841bb88174204d3b2ed1fb4c" => :mojave
    sha256 "085ae0758587544cf0f49c388579982d66fcd7db2806de4a6fc965f19119bd5e" => :high_sierra
    sha256 "de5daf23c19c4f34d5ba3a22ce0a2fd8ba9bda8e867620ea5a50106d71aeb031" => :sierra
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
