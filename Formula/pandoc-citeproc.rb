require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.14.7/pandoc-citeproc-0.14.7.tar.gz"
  sha256 "cd472234c436ce1baea57daa8431f3cd5b55dfa59dc8acded6d9831336be20a3"
  head "https://github.com/jgm/pandoc-citeproc.git"

  bottle do
    sha256 "525d821a2f25d6635d455a899def53cda2dc92dcb77ce0c6c053aabb852cf190" => :mojave
    sha256 "3fa95da724d7a5798a833781a9891bb861a2e180b09b637c5192dc0c75e67daf" => :high_sierra
    sha256 "9d6b717aa0989fbe80346a8d4d56bbee368fc620c4e893654f014494379bde0e" => :sierra
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
