require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.12.1.1/pandoc-citeproc-0.12.1.1.tar.gz"
  sha256 "08e6b8483cfaa4b8682a85f35f7423dc515bfa202646c3561dfcb98fa33cd9a8"
  head "https://github.com/jgm/pandoc-citeproc.git"

  bottle do
    sha256 "30a09ddb432f9a5b98df81daa06ef6ce9b3f8ffee602a72f5a5ddf58f5456feb" => :high_sierra
    sha256 "3ab7938a0ee23475bc2432bb3ba62333aac855fcd9905b810fbeb6ddd4575cbb" => :sierra
    sha256 "cf07c9da410196a44d474e1e35acc00de09c2ae8456338f2d15d5cbf5ae03d25" => :el_capitan
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
