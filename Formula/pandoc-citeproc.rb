require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.12.2.3/pandoc-citeproc-0.12.2.3.tar.gz"
  sha256 "87abaf8dbc6b539eddf745f11e0563f40896af128340825d331f5c5f3b0f0f87"
  head "https://github.com/jgm/pandoc-citeproc.git"

  bottle do
    sha256 "88c9bef35e1f71889941ea75fb1e91a2b15b5037154ed5e0f431e443a0afdde3" => :high_sierra
    sha256 "5d16a29b6d66e29295cba77ea6b11fbc3a1e7acc8b6f1b86e39f82726cc6fb75" => :sierra
    sha256 "2aa8699277c57452544f207e8d43c6c5f15e43ff8b649f09ac4655beb02d5317" => :el_capitan
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
