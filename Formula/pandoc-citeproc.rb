require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.16.1/pandoc-citeproc-0.16.1.tar.gz"
  sha256 "a3f12beef8dc8cd24c1365462a5d310a452f29ba6f9109e14ff974ff9b9fc36e"
  head "https://github.com/jgm/pandoc-citeproc.git"

  bottle do
    sha256 "21e5a47216685d6bf20bb87885dfce2a2544a55580b6ffaed7e414e2f0893ce3" => :mojave
    sha256 "5fd9ad6b54791116eca9817f7a672f187cd958c3671d64a6378de3a923c3fa4e" => :high_sierra
    sha256 "1557ad1512a580bd508d2b8320b4347905b99148828576f91c35b0b3ea7b3e00" => :sierra
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
