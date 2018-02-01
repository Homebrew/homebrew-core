require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.14.1/pandoc-citeproc-0.14.1.tar.gz"
  sha256 "6596430a52dca4f4808e56873b8e638267b122475b9cef5ce1ab42208a8d5325"
  head "https://github.com/jgm/pandoc-citeproc.git"

  bottle do
    sha256 "85b14630dd4d89a31f50cfe5cd63329a9de633d498ee5647ac2762a0833cee6c" => :high_sierra
    sha256 "5f0cd6343773fc977c79d2ad0383d973dbdbdb8b6ad7d75de0b25bca31263e88" => :sierra
    sha256 "9f3bf410685c0d8a2060cead0fc0851bf8e8fe5b10c9be12d5932272deaef7a4" => :el_capitan
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
