require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.9.1.1/pandoc-citeproc-0.9.1.1.tar.gz"
  sha256 "15c89a9aa6bce4efd6b728ea16151eb6390cad0495eb82c50cbac490591c8f86"

  bottle do
    sha256 "d1d591f9c6a9a47870e30e0cf5c84ebdaa5b25069413b8fa4826eb8cde429984" => :el_capitan
    sha256 "c74f862f3e1e60fe605c88cdedb94a53dc25027a0c7f18c53ac1c8858d99eaa4" => :yosemite
    sha256 "791274550dbb8028a2740dbfb7b7047b34c60a275a1f17a26219f5306dc7e04e" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "pandoc"

  def install
    # GHC 8 compat
    # Fixes "cabal: Could not resolve dependencies"
    # Reported 26 May 2016: https://github.com/jgm/pandoc-citeproc/issues/235
    (buildpath/"cabal.config").write("allow-newer: base,data-default,time\n")

    args = []
    args << "--constraint=cryptonite -support_aesni" if MacOS.version <= :lion
    install_cabal_package *args
  end

  test do
    bib = testpath/"test.bib"
    bib.write <<-EOS.undent
      @Book{item1,
      author="John Doe",
      title="First Book",
      year="2005",
      address="Cambridge",
      publisher="Cambridge University Press"
      }
    EOS
    system "pandoc-citeproc", "--bib2yaml", bib
  end
end
