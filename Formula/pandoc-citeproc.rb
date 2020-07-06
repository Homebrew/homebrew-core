require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.17.0.1/pandoc-citeproc-0.17.0.1.tar.gz"
  sha256 "f3e5ce3d1d21c27178f2fc69580750e3ce97fc5f962f2d01f7b6aa2e090c2342"
  license "BSD-3-Clause"
  head "https://github.com/jgm/pandoc-citeproc.git"

  bottle do
    sha256 "8aa3dc134d660c43794acdd2b63523497448050ed89e42cac976be9968ebc991" => :catalina
    sha256 "33d551134f7176547f6cb873ae0bee3d8c6a39a08a7b12dc1bc9c9ed7bb361a0" => :mojave
    sha256 "4d1c933cba04f09fd3aea5fb71694f8b0cd990a9453539cb02cb000e3f40f2c2" => :high_sierra
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
