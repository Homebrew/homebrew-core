require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.16.3/pandoc-citeproc-0.16.3.tar.gz"
  sha256 "0b0270eb24cbc48b3e6d37a8a91b1a600fa9fbdb898acc201c7398dec39144ca"
  head "https://github.com/jgm/pandoc-citeproc.git"

  bottle do
    sha256 "0be4e2584e55dbc15aa2c8786934acd87160bd2b60908f7ad56921fa6409fabc" => :mojave
    sha256 "cd176b21a8ff173adaaa5cbdd6890c9818b009d5058e812829a9086780e4c7c6" => :high_sierra
    sha256 "6b5dfa24e746e2fb4041b63341cdb7f893266bc8f3952b99960703477b1547a4" => :sierra
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
