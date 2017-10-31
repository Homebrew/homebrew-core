require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.0.0.1/pandoc-2.0.0.1.tar.gz"
  sha256 "9043d0ff9e7dd7d0feaa9e681cf63bf80c72caaab566333b45dba9f4f40e02f3"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "b7896def4340e3cd0d5ea06662500361c10b436d9a810b7bdfcee89768457126" => :high_sierra
    sha256 "2281ccaeaedb8a1d8aa664aee060ba8fd988879a917a30b73ea95e60001a0ad9" => :sierra
    sha256 "145059ffb08dc7e556ccc722cd45e9dcb6a028783f8768aa7c96daad39d67b1e" => :el_capitan
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
