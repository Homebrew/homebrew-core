require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.1/pandoc-2.1.tar.gz"
  sha256 "c2bbfacb3a15716353b63fd719e0041985b56499f40323d5c9ce9c81165a4aa4"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "e307fb584287e2022b53d0d4b59d0e9dff88177a8004c33fa77e97e945b5a506" => :high_sierra
    sha256 "0387e959bed5529a2ba830497eff8bdc10a3b3e8254b7884a55f2cff3dc1715d" => :sierra
    sha256 "4cd8cd2538c1f0ad176642fb3d65af30709acdef3190514529ac4097e84715a7" => :el_capitan
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
