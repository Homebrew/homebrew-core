require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.11.1.1/pandoc-citeproc-0.11.1.1.tar.gz"
  sha256 "9263721ae0017a48f884366eca37955d6983e7cf8571fafbccb49f28ab12e300"
  head "https://github.com/jgm/pandoc-citeproc.git"

  bottle do
    sha256 "394ffe844d4a0b91ef312e29053c267ae4088745c8add17de8a052d546c8bce5" => :high_sierra
    sha256 "13e19818179d37777015359c88586f7fa5bdd852347362a04f872c0298a9fab6" => :sierra
    sha256 "1ca09cfefa7b23bad3bb181fb747e6ae7edf214992ba45b78aeb02df5dba9844" => :el_capitan
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
