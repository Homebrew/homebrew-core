require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.14.3.1/pandoc-citeproc-0.14.3.1.tar.gz"
  sha256 "42c0b2c8365441bf884daa6202e6ed01b42181cf255406c88b3b31cd27cb467a"
  head "https://github.com/jgm/pandoc-citeproc.git"

  bottle do
    sha256 "9c7d98f09b2553afbe61cbeb08b1f4b6262c4f9e0e67412bd497b871e456bb21" => :high_sierra
    sha256 "37a3b76bf59608a4121e90600e7013dee49d76e007fe6e518fc6307357c06efe" => :sierra
    sha256 "e747286804a14831114798b85931905bfd4bc29033eeaf0b35139673b51a6d00" => :el_capitan
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
    (testpath/"test.bib").write <<~EOS
      @Book{item1,
      author="John Doe",
      title="First Book",
      year="2005",
      address="Cambridge",
      publisher="Cambridge University Press"
      }
    EOS
    expected = <<~EOS
      ---
      references:
      - id: item1
        type: book
        author:
        - family: Doe
          given: John
        issued:
        - year: 2005
        title: First book
        publisher: Cambridge University Press
        publisher-place: Cambridge
      ...
    EOS
    assert_equal expected, shell_output("#{bin}/pandoc-citeproc -y test.bib")
  end
end
