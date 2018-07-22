require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.2.2.1/pandoc-2.2.2.1.tar.gz"
  sha256 "f5f4c3ccf513ddbaf8c81d56bc2ef7a5ef2533ec664ef755fc651c9f5163a6a5"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "77e72ccb3672fbb11e03a41ea900fba789fbf7d33de3566f0070de9e2cfc4110" => :high_sierra
    sha256 "0df709ac10da734eda29f647503937002f06b72ae2a79c1c836d92cbd03ea3b2" => :sierra
    sha256 "e8406bfe86f0c74a1c00263efc41449c81bbe1588385683bb92dd2d315d00232" => :el_capitan
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
