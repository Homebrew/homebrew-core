require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.14.2/pandoc-citeproc-0.14.2.tar.gz"
  sha256 "853f77d54935a61cf4571618d5c333ffa9e42be4e2cccb9dbccdaf13f7f2e3b7"
  head "https://github.com/jgm/pandoc-citeproc.git"

  bottle do
    rebuild 1
    sha256 "0baecf261e6701b1ab7831f9bc0e7b0d2fc6cb238f944e418a738907db9983cf" => :high_sierra
    sha256 "fad1437315d030c29abdb2e31a704750e20bc40230ded72666d368ec023732bd" => :sierra
    sha256 "bbbac3aa232da8858a3c8699199120bb284ba675bd95d394a7726f4d58ddf8ca" => :el_capitan
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
