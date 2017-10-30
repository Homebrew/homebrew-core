require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.11.1.2/pandoc-citeproc-0.11.1.2.tar.gz"
  sha256 "4d9b70524e7ab05961ad9d7d33edeeeef369b6da519c63416b80155706906153"
  head "https://github.com/jgm/pandoc-citeproc.git"

  bottle do
    sha256 "9875580d411afb26829681c9b8c1ca2d446c154240fd55950d78fdc05ab9da27" => :high_sierra
    sha256 "56143a0ef3339120bf4d0a8960cded569fec9af2219f42630a486ea36a704c64" => :sierra
    sha256 "09e0e9f0c19aba3fa200552e9992c8277111199e75c1517bfd34a7368a0f05f2" => :el_capitan
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
