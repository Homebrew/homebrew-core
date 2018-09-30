require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.3.1/pandoc-2.3.1.tar.gz"
  sha256 "7451873d6b564e25f1def0444deb513e210466966e8318d57d7e146f7145c3f1"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "6623387431de172cb275cef457d23923104a5d906d928176c62fd37732d33de6" => :mojave
    sha256 "1caca0d16f20986bcc6eb486cfa086f88d54d9c30a1268a66449151220703585" => :high_sierra
    sha256 "ffc39384ea26958c8c2acd48d5579c944cf04e188ae9437f96eb5171efd643e8" => :sierra
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
