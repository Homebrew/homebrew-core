require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.14.1.5/pandoc-citeproc-0.14.1.5.tar.gz"
  sha256 "29e2afcdaaa23e5ac30e7f895bb45d36e0af79d4cfe769deb36c6f25fabfe2ca"
  head "https://github.com/jgm/pandoc-citeproc.git"

  bottle do
    sha256 "58aea109acada764ad4f8e829766e84a17e46fa669dcc3d409accb27ab46ee43" => :high_sierra
    sha256 "386b68cbace2437556cefb0369846f7976007a294dca884b6f4f9f2516e964e1" => :sierra
    sha256 "b4e50fc277e06126ef95cfc5bbc5970300535ff5ac0e259d45ffbbd428f74b23" => :el_capitan
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
