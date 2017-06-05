require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.10.5.1/pandoc-citeproc-0.10.5.1.tar.gz"
  sha256 "49038b80ad802098169852b0bc7fc7c9878a85a9091eee4c32211844fecda783"
  head "https://github.com/jgm/pandoc-citeproc.git"

  bottle do
    sha256 "56c23d135fce63ad09db11cc0744126ca5b3fefb78cd5947ebadcdf8a7b9a99e" => :sierra
    sha256 "a06feb1c2d27a1cf04b0621867270744412b05f787c551b9efb999316ce1fa39" => :el_capitan
    sha256 "8ebc9141f7d97894737905effd67e7335c6b5b967e1c38bed272ee2959673e7a" => :yosemite
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "pandoc"

  def install
    args = []
    args << "--constraint=cryptonite -support_aesni" if MacOS.version <= :lion
    install_cabal_package *args
  end

  test do
    (testpath/"test.bib").write <<-EOS.undent
      @Book{item1,
      author="John Doe",
      title="First Book",
      year="2005",
      address="Cambridge",
      publisher="Cambridge University Press"
      }
    EOS
    expected = <<-EOS.undent
      ---
      references:
      - id: item1
        type: book
        author:
        - family: Doe
          given: John
        issued:
        - year: '2005'
        title: First book
        publisher: Cambridge University Press
        publisher-place: Cambridge
      ...
    EOS
    assert_equal expected, shell_output("#{bin}/pandoc-citeproc -y test.bib")
  end
end
