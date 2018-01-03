require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.12.2.4/pandoc-citeproc-0.12.2.4.tar.gz"
  sha256 "5318c3bf5324282fcb11265ad6d452c940dd7a6d523c7150dcfed920e2f220a6"
  head "https://github.com/jgm/pandoc-citeproc.git"

  bottle do
    sha256 "4e61cd9e8af7bd31547579b4bef265653f28d40922ba13fbfeb7c19d79913ccf" => :high_sierra
    sha256 "075123cd935bd05a357ad882f1b9b170a7c7dd5685e5a3ee5a4727faedd3301f" => :sierra
    sha256 "22291384daf3b3fa4b03d0772367cee31437621f0968e3810ae33c1bf0421adf" => :el_capitan
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
        - year: '2005'
        title: First book
        publisher: Cambridge University Press
        publisher-place: Cambridge
      ...
    EOS
    assert_equal expected, shell_output("#{bin}/pandoc-citeproc -y test.bib")
  end
end
