require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.10.5.1/pandoc-citeproc-0.10.5.1.tar.gz"
  sha256 "49038b80ad802098169852b0bc7fc7c9878a85a9091eee4c32211844fecda783"
  head "https://github.com/jgm/pandoc-citeproc.git"

  bottle do
    sha256 "1340684299f24b273f7ea77c0d101fccc5974d444b2219bc4f13afb94275636a" => :sierra
    sha256 "4b044f54b46d897260a14d4503249d2910528acb96ede60a30680691babc77c0" => :el_capitan
    sha256 "5959f63d0a97096a9b9340429da1380287f86eb81d0bc2e0d78737cf55dea664" => :yosemite
  end

  depends_on "ghc@8.0" => :build
  depends_on "cabal-install" => :build
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
