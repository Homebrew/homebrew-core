require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.14.1.3/pandoc-citeproc-0.14.1.3.tar.gz"
  sha256 "b79251d9917c614a5f8ca150798df672f66afe52749b44a0cadd713920529c9d"
  head "https://github.com/jgm/pandoc-citeproc.git"

  bottle do
    sha256 "5f733c4ee371fc57019c6e7fd303d276972c6700b137d7547e23db8713fd4443" => :high_sierra
    sha256 "1ab599cffaa903666383ac6de6be0eb35e6d811e9b9abd9177a9f628e40b4d60" => :sierra
    sha256 "0478c311f0de7d46023b233f27bf7272c5619946709bea260ed4c299704bd98e" => :el_capitan
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
