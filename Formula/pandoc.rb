require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.1.2/pandoc-2.1.2.tar.gz"
  sha256 "dc0b26eff61c6eed2e00927fa2c6b966ca758dea1596f3049cc70ae8b650eb65"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "b4b46e5f6be33de5810282abff8e791e5d7a299d9034181d141267e748e54b5c" => :high_sierra
    sha256 "4ed83a74100cfdf80fbf4c604fbd97d41a037b3db41f074ffdca831626968749" => :sierra
    sha256 "175fd83ffef287801fbfff5b3222dce11060287f27532b55aa0e06ebc98dcc7c" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    cabal_sandbox do
      args = []
      args << "--constraint=cryptonite -support_aesni" if MacOS.version <= :lion

      # Remove pandoc-types constraint for pandoc > 2.1.2
      # Upstream issue from 13 Mar 2018 "Pandoc 2.1.2 failed building with GHC 8.2.2"
      # See https://github.com/jgm/pandoc/issues/4448
      install_cabal_package "--constraint", "pandoc-types < 1.17.4", *args
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
