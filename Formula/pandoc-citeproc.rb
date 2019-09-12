require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.16.2/pandoc-citeproc-0.16.2.tar.gz"
  sha256 "5b6725b003474f19fd7de65f3371a015a7b210b42543fe952f2bc4c7d509b596"
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
