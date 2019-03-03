require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.7/pandoc-2.7.tar.gz"
  sha256 "0421a7806b0a1370945c551c417523de8d6572c1adbdcd372d961fd644d5c38f"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "d31fe59eb2b0c59e1cdcf58f2e94650f51829d6723167975d01956fcb0a1a817" => :mojave
    sha256 "a73a2e0f3c5cbde40e74b675c62059265d48e086b2b7936934a49a825977417c" => :high_sierra
    sha256 "223e2e0d133b19ada445f8abef95a86ee2d20cdaa2b3aff7f08b12fe8278b781" => :sierra
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
