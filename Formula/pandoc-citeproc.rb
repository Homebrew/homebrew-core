require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.10.4.1/pandoc-citeproc-0.10.4.1.tar.gz"
  sha256 "6e6b0a89a831f9bfaa33dc0f3dff1792ee1626a5e66e1bd34da9447cd3c7de51"
  head "https://github.com/jgm/pandoc-citeproc.git"

  bottle do
    sha256 "1c99018d79ad1cf922690bb7934a0177a6deccc7b7e914ecd548ca29d2ebe21c" => :sierra
    sha256 "2bfd7a376de2152032cff391f78ccbff0b846638cd2d0546aa54da7ee135fc1c" => :el_capitan
    sha256 "b330b05b9f456418a9a66311271d5135cf6a5e85eddc02c7ba94b368c3f5674e" => :yosemite
  end

  depends_on "ghc" => :build
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
