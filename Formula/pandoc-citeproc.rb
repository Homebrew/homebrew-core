require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.14.3.1/pandoc-citeproc-0.14.3.1.tar.gz"
  sha256 "42c0b2c8365441bf884daa6202e6ed01b42181cf255406c88b3b31cd27cb467a"
  head "https://github.com/jgm/pandoc-citeproc.git"

  bottle do
    sha256 "ee04cdb88b75d757dd19685fc3e445f64504d5deb03c0dceda8aef1f678dd24e" => :mojave
    sha256 "27dc266011d69330c6e81d5e5334c158f2e7f03b1f8841047b1085e84030fb18" => :high_sierra
    sha256 "bd97c0c7bae22a29036bc4eba70c4a195ff10248f97740bb2919469e6cb159e7" => :sierra
    sha256 "9bc02f6ea655a565c99571a80ceb6f5b22fe57937740c0288e942a72b7ed8e9c" => :el_capitan
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
