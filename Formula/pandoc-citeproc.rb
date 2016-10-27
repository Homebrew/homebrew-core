require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.10.2.1/pandoc-citeproc-0.10.2.1.tar.gz"
  sha256 "025f88b4e1d5014692d1703d897f145a107752033d7aef202cac18b4d7887f5f"
  head "https://github.com/jgm/pandoc-citeproc.git"

  bottle do
    sha256 "3fb20df3481762bc3832d638c1a09b21fe5e39df4d0314a3b619c0a413596419" => :sierra
    sha256 "9ea68bf53585b7033415dfe6bde764ab98bd417e3bbd16c64b07ee496067ab00" => :el_capitan
    sha256 "a5d8a0b02b65e79283a6c2407a5519cb0c672efa11aa7017d640a1db10007ce0" => :yosemite
    sha256 "53dcdd90bf14f62f69db9d463234f91dd7548b51ed73ec482a3e614cd0e7edb3" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "pandoc"

  def install
    # Build error with aeson >= 1.0.0.0: "Overlapping instances for FromJSON"
    # Reported 27 Oct 2016 https://github.com/jgm/pandoc-citeproc/issues/263
    inreplace "pandoc-citeproc.cabal",
      "aeson >= 0.7 && < 1.1, text, vector,",
      "aeson >= 0.7 && < 1.0.0.0, text, vector,"

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
