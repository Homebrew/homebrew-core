require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.1.2/pandoc-2.1.2.tar.gz"
  sha256 "dc0b26eff61c6eed2e00927fa2c6b966ca758dea1596f3049cc70ae8b650eb65"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "3a64d164f6d903c46734fb86996b45ce2b1baf3f1a4b84c194152f52396f31f6" => :high_sierra
    sha256 "7c1e20d9c6de8fc9be6424f2a670b8560ce92a722f2f97613feb0ea86be7ec36" => :sierra
    sha256 "5fb007bddd8b7b6cf6aaa47b1336cdcec5419311b3712bb72afc2184a47033a9" => :el_capitan
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
