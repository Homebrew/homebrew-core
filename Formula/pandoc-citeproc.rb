require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.16.0.2/pandoc-citeproc-0.16.0.2.tar.gz"
  sha256 "4cc4c72a42df943e9cc60028c5154cc131423e32dd78ef18e43f790e2de65e59"
  head "https://github.com/jgm/pandoc-citeproc.git"

  bottle do
    sha256 "d3340b2e2dfabd3b7834d79dcd6bc3e6881bf8ff8590925a301935bc7715d848" => :mojave
    sha256 "4bbdebdd9869705997ca54174de6f1f5ac9b78df9c8637889bf4e67fca2eba8b" => :high_sierra
    sha256 "e91d2532e758a8a88d7bd1079110c2fdcbf609a4925255012dd67f526a7cf8a6" => :sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pandoc"

  def install
    install_cabal_package
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
