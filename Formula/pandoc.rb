require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.2.3/pandoc-2.2.3.tar.gz"
  sha256 "78e720c1b74008ae52df86706793e622953f9a7e7148f3fa0f422e236896a58f"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "3588aa1f55b6979395549ff56f1b607a0f88676133a6d4cf21cf03e2d3146922" => :high_sierra
    sha256 "3375ec411e164eae7cab98c3fc7aefc35061df84562033e203d8e073ab65238c" => :sierra
    sha256 "729d7a5402b8a160cc9becd43d16c03dc26bc408ca55a2dd6b95715a127d21d0" => :el_capitan
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
