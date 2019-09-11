require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.7.3/pandoc-2.7.3.tar.gz"
  sha256 "a877203379ec5179716d6999f76352229d7f40f5bec70dbfa48c140848cef236"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "bb4246119de8f6f8769d4a7baf3127ed66df0edd69bb84c92b1bdeaa90064caf" => :mojave
    sha256 "afe8cc21378449f87f55d10a36282018038e8ad9240b2c10cae28586760ea2e1" => :high_sierra
    sha256 "3e738f0e5e5ea97b918c0f123de502119b8ca000654c4b67831e4af7998f394a" => :sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    cabal_sandbox do
      install_cabal_package
    end
    (bash_completion/"pandoc").write `#{bin}/pandoc --bash-completion`
    man1.install "man/pandoc.1"
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
