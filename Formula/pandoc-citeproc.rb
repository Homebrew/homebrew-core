require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.16.2/pandoc-citeproc-0.16.2.tar.gz"
  sha256 "5b6725b003474f19fd7de65f3371a015a7b210b42543fe952f2bc4c7d509b596"
  head "https://github.com/jgm/pandoc-citeproc.git"

  bottle do
    sha256 "021d2219b634ae4e613e11b5a459988c5b89916b494b8daf5189aa16612d12a4" => :mojave
    sha256 "414a220656a182ee9add047099021969f7a0c444dec715e827b8e5ec9710782e" => :high_sierra
    sha256 "c140d93c9252aecdff4fa65879badc085de47e1efbe728362a73ee9db471d48d" => :sierra
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
