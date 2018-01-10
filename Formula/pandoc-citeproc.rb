require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.13/pandoc-citeproc-0.13.tar.gz"
  sha256 "0f1d010a8f63cf66727b2435cc399d1f45e747d6c8eaf8f20495a228ece0a276"
  head "https://github.com/jgm/pandoc-citeproc.git"

  bottle do
    sha256 "11d632d980277d170bf953e624762b25ed7d7c047a9c65861a184330b64fb935" => :high_sierra
    sha256 "63c095565fe11cb2dd449bdf9ec07881fb590d43ae5350b5c87c9fe7c518ae89" => :sierra
    sha256 "8b51b5b319a061f18eb1ad25fa70bc647bb3328f66c650369ecd91d3a4225191" => :el_capitan
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
