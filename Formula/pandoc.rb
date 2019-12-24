require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.9.1/pandoc-2.9.1.tar.gz"
  sha256 "0a543566be3468a0283d08cf6f3cda44c70de46b52755d902277273450d78bfb"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "b43c2aee646e251305be73f55b220d7efed805d8f5bd06e1a0405d42b0ef1240" => :catalina
    sha256 "274854736745432b9d0e43929f6e195fd5223c2facaba0ee8c93fff739e36d20" => :mojave
    sha256 "e00d5bc46792cfa035f39e3b5c65db9ee36b8c376d9fcb9fae3dabd108841f45" => :high_sierra
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
