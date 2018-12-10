require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.15.0.1/pandoc-citeproc-0.15.0.1.tar.gz"
  sha256 "29db5f2aad3225859727271855461724574f3695ab3856ceac33b24a55ae92f8"
  head "https://github.com/jgm/pandoc-citeproc.git"

  bottle do
    sha256 "d3340b2e2dfabd3b7834d79dcd6bc3e6881bf8ff8590925a301935bc7715d848" => :mojave
    sha256 "4bbdebdd9869705997ca54174de6f1f5ac9b78df9c8637889bf4e67fca2eba8b" => :high_sierra
    sha256 "e91d2532e758a8a88d7bd1079110c2fdcbf609a4925255012dd67f526a7cf8a6" => :sierra
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
