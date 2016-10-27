require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.10.2.1/pandoc-citeproc-0.10.2.1.tar.gz"
  sha256 "025f88b4e1d5014692d1703d897f145a107752033d7aef202cac18b4d7887f5f"
  head "https://github.com/jgm/pandoc-citeproc.git"

  bottle do
    sha256 "48bcea158acefbbb1e2b9973a52394f94ac6889212f956b945e0ed62375f584a" => :sierra
    sha256 "4398b169e21cf93282a4211cf43e35cbfcbc814b80590d776a7ab501091e815f" => :el_capitan
    sha256 "f7b904982f1bd1332dccd75c2ddaa91fd89004ef01aea9971fe772a3bcb77d65" => :yosemite
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
