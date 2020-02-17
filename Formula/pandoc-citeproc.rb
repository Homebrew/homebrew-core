require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.17/pandoc-citeproc-0.17.tar.gz"
  sha256 "47a9e7aac348d55eb935bee5ced30529974f4a680d67c38ea68be1d83edaf5b1"
  head "https://github.com/jgm/pandoc-citeproc.git"

  bottle do
    sha256 "3c18487d0f6c846276e10d519e27db8256e5e966f65f56fa4bbe81143b672fc9" => :catalina
    sha256 "b22213dfd417e4cf807730c6521d06c57b7e4f152d55c8a5df2440a8b0dc1ec3" => :mojave
    sha256 "0d72f1dcded6b07bd40344bb2f19f6a3fb8136ed55fe0da1bad1222460283578" => :high_sierra
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
