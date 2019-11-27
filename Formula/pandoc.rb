require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.8.0.1/pandoc-2.8.0.1.tar.gz"
  sha256 "fadf831f0de8498d096599d2b8b2e8044d4d0b92e99fe5b20e2da63044791a3d"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "c9641bec0e455030907d611a2fbca25d83ff343d4ebefdd5dbf0b4d6518ffc0b" => :catalina
    sha256 "ae1b0206c9e3665cc31ac39de3938a1195ce1bf252a607ea303584002d57b00c" => :mojave
    sha256 "f629c4a25cf0877cc323bf94f800794424b01956fca45369ca743e9d6d877ddf" => :high_sierra
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
