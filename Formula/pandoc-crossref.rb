require "language/haskell"

class PandocCrossref < Formula
  include Language::Haskell::Cabal

  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://hackage.haskell.org/package/pandoc-crossref-0.3.4.0/pandoc-crossref-0.3.4.0.tar.gz"
  sha256 "ff5515e76884aa0d7f9991fc22853622b185a92f940084d2d396133eddc56e97"

  bottle do
    cellar :any_skip_relocation
    sha256 "f393944b4015b3bf249f774e5cc7f242adb9a06ac2951e0d41e47c829b3d18f7" => :mojave
    sha256 "8ab28ffcd5baa7dbf4ddfc911bbafa1e9b1fb6dcd2191c4e36588a3ac867ad46" => :high_sierra
    sha256 "660fbcc8fdd583bcf3740c6fc8bd312b5970c3f4ff140b5ebc482bd1a4fc9afa" => :sierra
    sha256 "9ed94e5c687ca4962b15b99f79febbf00dac8a729338e9e4c44e7ee106a15e07" => :el_capitan
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
