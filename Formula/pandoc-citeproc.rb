require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.12.1.1/pandoc-citeproc-0.12.1.1.tar.gz"
  sha256 "08e6b8483cfaa4b8682a85f35f7423dc515bfa202646c3561dfcb98fa33cd9a8"
  head "https://github.com/jgm/pandoc-citeproc.git"

  bottle do
    sha256 "2e867de685323674fc29c26364fb189a4914a1b40260bb22c864248bc1594b65" => :high_sierra
    sha256 "75a3ddc5d87b6c713d5cafe5bb6b537394e7cfa893291ead98bc20baa92ce13a" => :sierra
    sha256 "f35d0cad18119c0c392da4742153cd9e30295f9be1ba3193b9f71d6613567baf" => :el_capitan
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
