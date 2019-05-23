require "language/haskell"

class PandocCrossref < Formula
  include Language::Haskell::Cabal

  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://hackage.haskell.org/package/pandoc-crossref-0.3.4.1/pandoc-crossref-0.3.4.1.tar.gz"
  sha256 "de22767a19cb8b58fb77be4e85e05040e68830b37eb565afa6f63c8da7221aa6"

  bottle do
    cellar :any_skip_relocation
    sha256 "b0fa6168a6ea1ee11fef90adb7efad220e8ed63c7929bea59af5d6e594449496" => :mojave
    sha256 "d530921cde82795081d8c3fae684eecfb254641c9e0e8101197196dbf8390aa5" => :high_sierra
    sha256 "317f60c2fa7fdb295dc4f9608e8ee275fc3ebfe5b5b196346b475ec43e7a414a" => :sierra
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
