require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.14.1.2/pandoc-citeproc-0.14.1.2.tar.gz"
  sha256 "d17dc21a3ddcac8c555ddf380e519a41c394e7592319145cca2c7a7f50bcdd18"
  head "https://github.com/jgm/pandoc-citeproc.git"

  bottle do
    sha256 "b1a9dc5e0af0d55bae5228e7568c4426c92ada742b3b9d3800a1a3d615135c38" => :high_sierra
    sha256 "5bae25685acf92c36feed3e8f2df4ddbd08be139b3a72d1cc1ccfb4a1901fa35" => :sierra
    sha256 "696b495404ab56838ca74d7d9dd31499800c858c5b875890cdd5888432ad074f" => :el_capitan
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
