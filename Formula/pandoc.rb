require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.0.5/pandoc-2.0.5.tar.gz"
  sha256 "91245ae9f4a329883285bb13b9445b7c3d6a13d1d54baef34d9cfd47f777e018"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "894b71e83dde94acef848c22e84041f438cfe0d1f90df83217840be989e31886" => :high_sierra
    sha256 "2207cd27f42dcce3341ea1c03b730f87f65d29513fd1b5d96fcc4959a1c3747d" => :sierra
    sha256 "36c95eae639671f55f1927d62ba2bd3f2ca12818b5ff401efb7a554aa84db22c" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    cabal_sandbox do
      args = []
      args << "--constraint=cryptonite -support_aesni" if MacOS.version <= :lion
      install_cabal_package *args
    end
    (bash_completion/"pandoc").write `#{bin}/pandoc --bash-completion`
  end

  test do
    input_markdown = <<~EOS
      # Homebrew

      A package manager for humans. Cats should take a look at Tigerbrew.
    EOS
    expected_html = <<~EOS
      <h1 id="homebrew">Homebrew</h1>
      <p>A package manager for humans. Cats should take a look at Tigerbrew.</p>
    EOS
    assert_equal expected_html, pipe_output("#{bin}/pandoc -f markdown -t html5", input_markdown)
  end
end
