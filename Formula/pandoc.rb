require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.3.1/pandoc-2.3.1.tar.gz"
  sha256 "7451873d6b564e25f1def0444deb513e210466966e8318d57d7e146f7145c3f1"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "0d857ce77b83fbf206532b7c9e2023a28b79615b2e1b0cee29d95df385df0a5d" => :mojave
    sha256 "824274da6a50b9f5a3fdb55dbbaf6b928abdf2e307ee9d14f6f7a60402c27ba2" => :high_sierra
    sha256 "5c5714e8405654edb77b47d414e40890db1c17e48c5a190a41eb53a90f69d311" => :sierra
    sha256 "982e1dd2052705ba6a112771b82b1e64b8f0f8040cf1e6d5be8a130c0fae8311" => :el_capitan
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
