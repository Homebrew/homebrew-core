require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-1.19.2.4/pandoc-1.19.2.4.tar.gz"
  sha256 "bbe08c1f7fcfea98b899f9956c04159d493a26f65d3350aa6579aa5b93203556"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "5a4e56b970e59984fda8cf03c3d89ce6a100f28aa7defaf2da28f68498419902" => :high_sierra
    sha256 "e5fcff4739015b69fc513900e20a8d1130a98bb29ae7770f02d4832e80841729" => :sierra
    sha256 "bfdaf40b035d17d9323d3bf736d433b109f1cf4942a9c2e2b211d065f49ae51f" => :el_capitan
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
