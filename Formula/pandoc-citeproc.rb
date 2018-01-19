require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.14/pandoc-citeproc-0.14.tar.gz"
  sha256 "a2906864e0312f59c644e4e7bb86c888c84e7f78d7b66d6e789864beb39b6bdd"
  head "https://github.com/jgm/pandoc-citeproc.git"

  bottle do
    sha256 "dae3fbb40f5db40d530a6ae0a9e9de775df13297206821116eeed0aeab05608e" => :high_sierra
    sha256 "f999b43bfb052384a669af2573e56436bfd50c06cb102ce862340eae50c0b4b9" => :sierra
    sha256 "aab25851baa2c1a3423c677e667d6b61407a8cef40d4b39f2b88b66e08e2000b" => :el_capitan
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
