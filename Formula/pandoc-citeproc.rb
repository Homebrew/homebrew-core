require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.12.2.5/pandoc-citeproc-0.12.2.5.tar.gz"
  sha256 "ddfb40b4ff42e1781172bf1077e344fb8909df99b3463c12b39f5a46ddb2a8d0"
  head "https://github.com/jgm/pandoc-citeproc.git"

  bottle do
    sha256 "100d0ef1cccf69729f4176a2de08ca856b29610731433768268d17f95fa0daff" => :high_sierra
    sha256 "85dda805b8cc8ee862811bd656359193e70ac8782781a3d352144910492847f8" => :sierra
    sha256 "795cca06f55370047310d5be5a47a1cd9fe8865590f582b247cbbcf4181fd1a7" => :el_capitan
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
