require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.6/pandoc-2.6.tar.gz"
  sha256 "aa761fe96161d042e01d0881fa569ec396da02ebce42562e04fbd91d8ff2db10"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "c66385503b793d3ee1167bcce5deb8b29f6477f932554df4a9d0663c398b4d1f" => :mojave
    sha256 "4c3d37b8c0fb470843a48e63c95995635515a5917a3535f8704f4eb8734d0297" => :high_sierra
    sha256 "bf01b44e4123a864f0f1b17b78b65942ca729be61783a91921f720799552dcba" => :sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    cabal_sandbox do
      install_cabal_package
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
