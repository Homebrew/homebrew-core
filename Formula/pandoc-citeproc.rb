require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.17/pandoc-citeproc-0.17.tar.gz"
  sha256 "47a9e7aac348d55eb935bee5ced30529974f4a680d67c38ea68be1d83edaf5b1"
  head "https://github.com/jgm/pandoc-citeproc.git"

  bottle do
    sha256 "8b38e14cba5362ab9ac910e2924d1c79ea7800d6b8fb3dbd825bac0746187c4c" => :catalina
    sha256 "6e70e2154996d8c16da1961824b3579681299867155ba018cc1dee8b72982358" => :mojave
    sha256 "b3ce62be557edfe6c40578d6d1473e4a4320eba61986f9a2e28f1f2d798482ce" => :high_sierra
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
