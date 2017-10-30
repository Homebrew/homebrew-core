require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.0/pandoc-2.0.tar.gz"
  sha256 "8875206e7dd25f085ad5f6a34f6b07de680dbb584c57bb41332eafb76e4a43ee"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "aa7f1b3acb30a747e9a8425ab0808a67e74405350ae7a1303fc32e1040bea9e9" => :high_sierra
    sha256 "ff98beafc13a908560f6d30ded4199bb6cb4a2c75919cc1424f2f8c8b2506a40" => :sierra
    sha256 "2efb9303ec48dd66acde60aaf3eb157d4420a4fa309d9686da481f1a3ec9f3ca" => :el_capitan
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
