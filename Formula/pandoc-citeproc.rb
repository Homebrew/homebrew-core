require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.17.0.1/pandoc-citeproc-0.17.0.1.tar.gz"
  sha256 "f3e5ce3d1d21c27178f2fc69580750e3ce97fc5f962f2d01f7b6aa2e090c2342"
  head "https://github.com/jgm/pandoc-citeproc.git"

  bottle do
    rebuild 1
    sha256 "5417a60c9e6f59cd5c7d1206a90e986588a1e6d48a928d2fba0f7ce2a7e540e2" => :catalina
    sha256 "431f2e063e7555bd3af98244cdc08433af6418ceb7eaa8fba9b709d091f53747" => :mojave
    sha256 "cf3941aa8eb4a7256072702cef20285c45e122a0f76e547c220963905a78e5a7" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.8" => :build
  depends_on "pandoc"

  uses_from_macos "unzip" => :build

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
