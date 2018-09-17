require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.3/pandoc-2.3.tar.gz"
  sha256 "5b051a1bb7b894eefa1464ffce972df3bbd8a000286c4471fe8ca98a5806ce73"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "c2225bafe9a308cee0e8c22759c385ca0095a988ecafb5a7b9dd38eada99fd15" => :mojave
    sha256 "ed9075ac91fe652ee287ca0a10b1b71721e29577720155f38971ff8816b93b96" => :high_sierra
    sha256 "899afd12294ac0ff27a1f5aee1e042dc88cb88dc831ef0e83ae93d65ec46f4e2" => :sierra
    sha256 "d1a0ab671ff89632c9365900ea2ba139ea8b93d49750fe94909635cef8fcd84c" => :el_capitan
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
