require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.2.2/pandoc-2.2.2.tar.gz"
  sha256 "0c371bed505b61685389773817e3a23fd0f0df3212d3b764eedfcd5365357965"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "3c6b10a6db60d8b68e3da7537f1a3e767de4170c895c9e7c823c446d4832d67d" => :high_sierra
    sha256 "22645dfa0962ababf75637e92cb3fd70d72d915eaf1e5463657b2da45cbe2a6b" => :sierra
    sha256 "d872408b8c4be75bda3db4df96fb00fe2eeda4402bdbd1c565e49c6097fb33a2" => :el_capitan
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
