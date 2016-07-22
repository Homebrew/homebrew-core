require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.10.1/pandoc-citeproc-0.10.1.tar.gz"
  sha256 "ebc3eb3ff95e97ebd46c0918a65db2da021de2a70d02dc85ca5b344ea5c21205"
  head "https://github.com/jgm/pandoc-citeproc.git"

  bottle do
    sha256 "9ea68bf53585b7033415dfe6bde764ab98bd417e3bbd16c64b07ee496067ab00" => :el_capitan
    sha256 "a5d8a0b02b65e79283a6c2407a5519cb0c672efa11aa7017d640a1db10007ce0" => :yosemite
    sha256 "53dcdd90bf14f62f69db9d463234f91dd7548b51ed73ec482a3e614cd0e7edb3" => :mavericks
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
