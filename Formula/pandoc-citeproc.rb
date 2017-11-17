require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.12.1/pandoc-citeproc-0.12.1.tar.gz"
  sha256 "7f12b25b0cf2f7c1ffe376d54113b6a85da0548d7b73e52e6d66f5daf65fc2ac"
  head "https://github.com/jgm/pandoc-citeproc.git"

  bottle do
    sha256 "9d571e2e0228c4af81d46cbcd29eb566769de02bb0e8fbf2d385731f26041390" => :high_sierra
    sha256 "9e360fd98b8e991fdf5a1aff04c4948d3ee874c61ff861d2483a52344f194e2a" => :sierra
    sha256 "25f1b575f27ee8d4141aac7c4c020346f4180b3d5e57af58079b3630ded84a46" => :el_capitan
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
