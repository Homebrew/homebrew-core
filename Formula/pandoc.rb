require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.0.5/pandoc-2.0.5.tar.gz"
  sha256 "91245ae9f4a329883285bb13b9445b7c3d6a13d1d54baef34d9cfd47f777e018"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "3b227234198cc274441677dcba80783d77cf757ee22bdf99e3b3c908ddac0905" => :high_sierra
    sha256 "da1455f22c8c8cfd907a24c6c61c727eab8f1ef8137cc9dbe152bacb9b4ae660" => :sierra
    sha256 "67f2f19df5a3bc7f44f80393bd14830c3a128f0a0d9ee6d32794ae9e4c79044a" => :el_capitan
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
