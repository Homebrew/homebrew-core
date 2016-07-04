require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.10/pandoc-citeproc-0.10.tar.gz"
  sha256 "2465117b5e922d8c93f6ebf3b99d76c90d31573d01bd9935f5a1cc7be1cdb702"

  bottle do
    sha256 "5f16f5f4ce037f4d05b410f34fd2b0fef41b61242e3545ba5911970299ade510" => :el_capitan
    sha256 "73913876e4bb0cd0ae50123f9d83a1c9b9145e8d3a98f14c83b8db39bdc99000" => :yosemite
    sha256 "bff9c16c0e63fde0af42b37d69cc1be5f5619154f93daf967b845b4a0aa7c78b" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "pandoc"

  def install
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
