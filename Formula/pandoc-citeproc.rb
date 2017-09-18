require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.11.1.1/pandoc-citeproc-0.11.1.1.tar.gz"
  sha256 "9263721ae0017a48f884366eca37955d6983e7cf8571fafbccb49f28ab12e300"
  head "https://github.com/jgm/pandoc-citeproc.git"

  bottle do
    sha256 "b8a2f31f55f219ada600e69944355f14f839bb50274452307f1eabfd9b5e38c2" => :sierra
    sha256 "f29d1f4435b658a5e8ece4403b84d3352022fa1551eddaed2a2e417ae0b9b0e3" => :el_capitan
    sha256 "8caeaa0f4d250b7587c5f944cbeb276cf2b9782b53da6840a975e81dffb0a894" => :yosemite
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
