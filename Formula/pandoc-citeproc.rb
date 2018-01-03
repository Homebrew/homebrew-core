require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.12.2.4/pandoc-citeproc-0.12.2.4.tar.gz"
  sha256 "5318c3bf5324282fcb11265ad6d452c940dd7a6d523c7150dcfed920e2f220a6"
  head "https://github.com/jgm/pandoc-citeproc.git"

  bottle do
    sha256 "5ca002d0b3f6bf9e2229c898588d30b1694847827c2d1592c8f0b09b29c7d7d5" => :high_sierra
    sha256 "979b031d8bd45f28f35d6ffa6557d30ae169ff8b50e09f8518f7770b667d48b7" => :sierra
    sha256 "116afd7fba01ff98d7a1a5d68db65d8d6d9fca37bc887978f2dc22c3cff33c79" => :el_capitan
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
