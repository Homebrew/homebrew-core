require "language/haskell"

class Cless < Formula
  include Language::Haskell::Cabal

  desc "Display file contents with colorized syntax highlighting"
  homepage "https://github.com/tanakh/cless"
  url "https://github.com/tanakh/cless/archive/0.3.0.0.tar.gz"
  sha256 "382ad9b2ce6bf216bf2da1b9cadd9a7561526bfbab418c933b646d03e56833b2"
  revision 1

  bottle do
    rebuild 1
    sha256 "13a58ff321351e824e1972af009610772fba593cebcb49449eef10ad43413ed5" => :sierra
    sha256 "4d6c49c06cf947e75aaaef79f45b13d25c343641312639ad16b9745615169dff" => :el_capitan
    sha256 "ef83bdacb690d95de845c03b12b8c18819ac7a1733cc97e46755be79ac17fdf3" => :yosemite
    sha256 "7e5f360fccaee62ea35aaba208d88a20e64fabf4a512da71323191cd582fb35d" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    # GHC 8 compat
    # Reported 25 May 2016: https://github.com/tanakh/cless/issues/3
    # Also see "fix compilation with GHC 7.10", which has the base bump but not
    # the transformers bump: https://github.com/tanakh/cless/pull/2
    (buildpath/"cabal.config").write("allow-newer: base,transformers\n")

    install_cabal_package
  end

  test do
    system "#{bin}/cless", "--help"
    system "#{bin}/cless", "--list-langs"
    system "#{bin}/cless", "--list-styles"
  end
end
