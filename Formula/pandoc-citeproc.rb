require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.14.5/pandoc-citeproc-0.14.5.tar.gz"
  sha256 "e8d71c016b7949e8ac25dff19773920ec1f52ca4ce1128ca4dc2212b5c892a46"
  head "https://github.com/jgm/pandoc-citeproc.git"

  bottle do
    sha256 "cccc12bf4a5a10a250e1879c14996b7ba263524392e3602e59fe90caecba2454" => :mojave
    sha256 "0a271508a35aed2c0c1b6b37d8b26a7e87ff96e428857f58477c4952ba31b623" => :high_sierra
    sha256 "24335a1c6cbadc80a6f9ecc113d87775454ec04efea70e5c48ff940ecfc7104e" => :sierra
    sha256 "816f061eb300b15c8b51bbc26144f299bc292507cf712f67d04e0ef6f614de12" => :el_capitan
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
