require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.14.8/pandoc-citeproc-0.14.8.tar.gz"
  sha256 "f4a3c160688ab26afb2d1cdb64494b5282532d375c6c6278a90d3b4d8d35adff"
  head "https://github.com/jgm/pandoc-citeproc.git"

  bottle do
    sha256 "61432db9db134a7e2a7fce5f5ace4b66cf6b5fbdd601a159048d5a4a10828042" => :mojave
    sha256 "7f90dff435e5f54274d75f1e85eb9a38b8589d18064b3b58e543ca6c439441b3" => :high_sierra
    sha256 "3f034a9436415bf8d20188a44c8a7ec5a7272f2e9b7cf9b5eccbb0c75ffaf212" => :sierra
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
