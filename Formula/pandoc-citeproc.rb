require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.16.0.2/pandoc-citeproc-0.16.0.2.tar.gz"
  sha256 "4cc4c72a42df943e9cc60028c5154cc131423e32dd78ef18e43f790e2de65e59"
  head "https://github.com/jgm/pandoc-citeproc.git"

  bottle do
    sha256 "ffe30c1bc54c788b3d9b05856fa7c74da14af1ee46dedc5e754abc69bd0afb08" => :mojave
    sha256 "b34d84d57ad30dc71ed17cd26728f3fde3b727c4dd9a3a38c15dee37e2da34a3" => :high_sierra
    sha256 "e14bc5a68ecc834a5bcda11c09d29ffee872b1022824e4b25601e77610353404" => :sierra
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
